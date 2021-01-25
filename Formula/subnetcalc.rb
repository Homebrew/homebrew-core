class Subnetcalc < Formula
  desc "IPv4/IPv6 subnet calculator"
  homepage "https://www.uni-due.de/~be0001/subnetcalc/"
  url "https://www.uni-due.de/~be0001/subnetcalc/download/subnetcalc-2.4.17.tar.xz"
  sha256 "90f1a1a82f6e6fd4308511dfdabc3ed86bf75a11635645647f75ef4e2a6319ff"
  license "GPL-3.0"
  head "https://github.com/dreibh/subnetcalc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e0914221773eb6805b107278fe488525c655afe891d8575bf6123c8716824bf" => :big_sur
    sha256 "a0bcbd1fecfa6b7e53f87179db7b40d2e1a9103e54897c619b492a7c8af38022" => :arm64_big_sur
    sha256 "a75a2bd86939439d349617d4f9bcebfd2cd06fd8521259ae528618de3498ea13" => :catalina
    sha256 "4f04ffbceed2e9f1d9a5f8d04e92303ec8d8cc677d1931670fea0ee7d0c84259" => :mojave
    sha256 "a08ec739f53261955b4d4478be8347adb76d7061e0e61b776e2ff42539747159" => :high_sierra
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
