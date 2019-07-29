class Veclibfort < Formula
  desc "GNU Fortran compatibility for Apple's vecLib"
  homepage "https://github.com/mcg1969/vecLibFort"
  url "https://github.com/mcg1969/vecLibFort/archive/0.4.2.tar.gz"
  sha256 "c61316632bffa1c76e3c7f92b11c9def4b6f41973ecf9e124d68de6ae37fbc85"
  revision 6
  head "https://github.com/mcg1969/vecLibFort.git"

  bottle do
    cellar :any
    sha256 "cfc57cf7c918e03eca808df69b322b150802aeee21bfafcd3906d52cdf4d8598" => :mojave
    sha256 "482b9bd9210a7b32c30e4536d77529110f7a85399c83efd370f2612e9dd60d65" => :high_sierra
    sha256 "f655ad9b96a1e13a17dd757a598608850634ccc04fb52436e3f838f588ffe157" => :sierra
    sha256 "c91bb504dc969a045cbfc837b7f54de5e04012894b835a3b39ed1a6dc075d52f" => :el_capitan
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
