class Subnetcalc < Formula
  desc "IPv4/IPv6 subnet calculator"
  homepage "https://www.uni-due.de/~be0001/subnetcalc/"
  url "https://www.uni-due.de/~be0001/subnetcalc/download/subnetcalc-2.4.11.tar.gz"
  sha256 "19f18676c2e1f4559061f48e2f3378d8aad3f095822ad26e0e809ee46e684974"
  head "https://github.com/dreibh/subnetcalc.git"

  bottle do
    cellar :any
    sha256 "5ac3863b8d71a7e6da719f1574e4d02da387ec3a71716cf7db30504c8f49a6ed" => :mojave
    sha256 "4c64ad7c4ad2988b5b695e032676b334e6c91d7fae30aa9aa753d0a624a67617" => :high_sierra
    sha256 "533a4e4166f993e791baf729e420fc7fb26b1cc4353b05d2d8d64edb36b36181" => :sierra
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
