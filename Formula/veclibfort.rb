class Veclibfort < Formula
  desc "GNU Fortran compatibility for Apple's vecLib"
  homepage "https://github.com/mcg1969/vecLibFort"
  url "https://github.com/mcg1969/vecLibFort/archive/0.4.2.tar.gz"
  sha256 "c61316632bffa1c76e3c7f92b11c9def4b6f41973ecf9e124d68de6ae37fbc85"
  revision 5
  head "https://github.com/mcg1969/vecLibFort.git"

  bottle do
    cellar :any
    sha256 "25835893af5a10d804e69da1bc6ea998e2de9be5585d39cf8869b42f4d34d1d0" => :high_sierra
    sha256 "62d957a0a6448a180babab06bbc02ec1cc87eec18a19f4f5cdaac7b86e0c3d69" => :sierra
    sha256 "d713b2879ad5a435e3adcc7ed50ad8c3e99e7e17abd57bef3940f1dcbd5dbfae" => :el_capitan
    sha256 "6dcd136a00a22f25301da83534a6faf0171b391e00baf45b790d04d551c7202e" => :yosemite
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
