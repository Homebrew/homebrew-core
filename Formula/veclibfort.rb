class Veclibfort < Formula
  desc "GNU Fortran compatibility for Apple's vecLib"
  homepage "https://github.com/mcg1969/vecLibFort"
  url "https://github.com/mcg1969/vecLibFort/archive/0.4.2.tar.gz"
  sha256 "c61316632bffa1c76e3c7f92b11c9def4b6f41973ecf9e124d68de6ae37fbc85"
  head "https://github.com/mcg1969/vecLibFort.git"

  depends_on :fortran

  def install
    system "make", "all"
    system "make", "PREFIX=#{prefix}", "install"
    pkgshare.install "tester.f90"
  end

  test do
    ENV.fortran
    system ENV.fc, "-o", "tester", "-O", pkgshare/"tester.f90",
                   "-L#{lib}", "-lvecLibFort"
    assert_match "SLAMCH", shell_output("./tester")
  end
end
