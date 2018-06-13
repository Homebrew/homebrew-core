class Subnetcalc < Formula
  desc "IPv4/IPv6 subnet calculator"
  homepage "https://www.uni-due.de/~be0001/subnetcalc/"
  url "https://www.uni-due.de/~be0001/subnetcalc/download/subnetcalc-2.4.9.tar.gz"
  sha256 "dce27b53857625fdec0409b6534f89eb573d19cc2928ef6d81845902a759cbe9"
  head "https://github.com/dreibh/subnetcalc.git"

  bottle do
    cellar :any
    sha256 "c730ad755d22afd5e2fd2017910c4d69d693813fb632d761ea52992847b47f88" => :high_sierra
    sha256 "29f37e42624b4fb437bf7795c0341f3b1b2e31dcf025b796b6a198532c21ba4b" => :sierra
    sha256 "5d90401c8ef320206a3479945b536c0dace81e1c18bfcd3ce67d418fea059b55" => :el_capitan
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
