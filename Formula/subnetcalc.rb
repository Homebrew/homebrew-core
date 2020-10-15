class Subnetcalc < Formula
  desc "IPv4/IPv6 subnet calculator"
  homepage "https://www.uni-due.de/~be0001/subnetcalc/"
  url "https://www.uni-due.de/~be0001/subnetcalc/download/subnetcalc-2.4.16.tar.xz"
  sha256 "37dae5da0b5d0423ee44d6b86cf811ca6fb78e0768ce9d77b95544634ce68390"
  license "GPL-3.0"
  head "https://github.com/dreibh/subnetcalc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3292425456f8c87e8d3d468421de889ac20f859e4d00530646c973581ffc4543" => :catalina
    sha256 "d8537fab1388a387ab985bfdd841b106bccd663fbc0d53062af8cbdcaa9c7d35" => :mojave
    sha256 "367c6a6f8104ecee70216a06545e2b7e1eb81ffb887b6b4e335cd5acd1d56e67" => :high_sierra
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
