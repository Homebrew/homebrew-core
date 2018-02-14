class Veclibfort < Formula
  desc "GNU Fortran compatibility for Apple's vecLib"
  homepage "https://github.com/mcg1969/vecLibFort"
  url "https://github.com/mcg1969/vecLibFort/archive/0.4.2.tar.gz"
  sha256 "c61316632bffa1c76e3c7f92b11c9def4b6f41973ecf9e124d68de6ae37fbc85"
  revision 5
  head "https://github.com/mcg1969/vecLibFort.git"

  bottle do
    cellar :any
    sha256 "442c8d7afac816004009e35cf45ea9c9a81bac6425c57822dc838f7521ffaaf4" => :high_sierra
    sha256 "9431506c5f41a5a6456f7b785312e876b7e2b850d63ef2a8ba86c545da2ad7f9" => :sierra
    sha256 "4d8b0f4ab2442f7aeed6c05de39cba14757fa46aff743ad7756bf1d76e762d51" => :el_capitan
  end

  depends_on "gcc" # for gfortran

  def install
    system "make", "all"
    system "make", "PREFIX=#{prefix}", "install"
    pkgshare.install "tester.f90"
  end

  test do
    system "gfortran", "-o", "tester", "-O", pkgshare/"tester.f90",
                       "-L#{lib}", "-lvecLibFort"
    assert_match "SLAMCH", shell_output("./tester")
  end
end
