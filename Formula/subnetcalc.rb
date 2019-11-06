class Subnetcalc < Formula
  desc "IPv4/IPv6 subnet calculator"
  homepage "https://www.uni-due.de/~be0001/subnetcalc/"
  url "https://www.uni-due.de/~be0001/subnetcalc/download/subnetcalc-2.4.14.tar.xz"
  sha256 "a602cdc8f79fcfcf053c57a0747d0aeda156afeeac1b0facfdac1d0acbae469c"
  head "https://github.com/dreibh/subnetcalc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a8ee90e354ce39bd02d8ad7baa4ef0575d26c1a78cc16264c61e3da6a6da5ca" => :catalina
    sha256 "cb1f6dd2854ca7d6049d8c7336ba4ac5537b3927057753f2ca36a58f8bee842f" => :mojave
    sha256 "ff67b614cd174896b3ad818df3b98aedd8741bb7d9345c12fec9946f1c3ad022" => :high_sierra
    sha256 "43aa559cbf9c1253bc95a0fda1a9036b2c7b334b38a0bfae95091f1502f61a35" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "geoip"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/subnetcalc", "::1"
  end
end
