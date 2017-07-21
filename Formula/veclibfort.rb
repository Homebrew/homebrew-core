class Veclibfort < Formula
  desc "GNU Fortran compatibility for Apple's vecLib"
  homepage "https://github.com/mcg1969/vecLibFort"
  url "https://github.com/mcg1969/vecLibFort/archive/0.4.2.tar.gz"
  sha256 "c61316632bffa1c76e3c7f92b11c9def4b6f41973ecf9e124d68de6ae37fbc85"
  head "https://github.com/mcg1969/vecLibFort.git"

  bottle do
    cellar :any
    sha256 "d3a27662e9bf87f53000324700c661a107236f32abf3702f255de3c5469b8058" => :sierra
    sha256 "53dd645bb5cf38b0343cbab1f2fb02ea7e8843bb598b596de9adb26edb4e4709" => :el_capitan
    sha256 "5ae8a159cb6706f6a724682ac36ee765187ec336440b6cff5668e8d0ca40d3cf" => :yosemite
  end

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
