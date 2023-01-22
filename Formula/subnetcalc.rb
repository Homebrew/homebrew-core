class Subnetcalc < Formula
  desc "IPv4/IPv6 subnet calculator"
  homepage "https://www.nntb.no/~dreibh/subnetcalc/index.html"
  url "https://github.com/dreibh/subnetcalc/archive/refs/tags/subnetcalc-2.4.21.tar.gz"
  sha256 "43b5c162496529238e4261ac8f562f04965b4ee1956c508b6c1c78c7e7cc3ca2"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/subnetcalc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb9a97d4624ba2eb1e41b0bb8fbbdcdec86983dcffed476c9c4441a11a639ecb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "427da5c6383dd9a3307ec30c9a975ca5456f7b2c27b59d433991b25d613f0576"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "305a22c7217e51ad68f175bb9958d69474f8f4e1d2316d69ca49032302fa9eb5"
    sha256 cellar: :any_skip_relocation, monterey:       "1afef375229983906d16d2dc28801d71b651cd29a118626f15448ad8d2439a87"
    sha256 cellar: :any_skip_relocation, big_sur:        "97c26adfa53f4ec1e1d546040ae4f21416f6b8737cea762e6c4a2d1abbf11631"
    sha256 cellar: :any_skip_relocation, catalina:       "2cba9786049522b242944fb71cb2a6cbbeb8ffa38616c7f6624b6c651e6a4c95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d6133da67859d9980c7fab8e57aaf87238083c72e989378915495250100e799"
  end

  depends_on "cmake" => :build
  depends_on "geoip"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    expected = <<~EOS
      Address       = 1.1.1.1
                         \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m . \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m . \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m . \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m
      Network       = 1.1.1.1 / 32
      Netmask       = 255.255.255.255
      Broadcast     = not needed on Point-to-Point links
      Wildcard Mask = 0.0.0.0
      Hosts Bits    = 0
      Max. Hosts    = 1   (2^0 - 0)
      Host Range    = { 1.1.1.1 - 1.1.1.1 }
      Properties    =
         - 1.1.1.1 is a NETWORK address
         - Class A
      Performing reverse DNS lookup ...\r\e[KDNS Hostname  = one.one.one.one
    EOS
    assert_equal expected, shell_output("#{bin}/subnetcalc 1.1.1.1/32")
  end
end
