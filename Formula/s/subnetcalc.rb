class Subnetcalc < Formula
  desc "IPv4/IPv6 subnet calculator"
  homepage "https://www.nntb.no/~dreibh/subnetcalc/index.html"
  url "https://github.com/dreibh/subnetcalc/archive/refs/tags/subnetcalc-2.4.22.tar.gz"
  sha256 "4df8ddb2738400ccdd0e00a45a4ce53b73ec0592b9faa8144289d7fc08443dda"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/subnetcalc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87c388a7eebfa381d87e22863be09d64b357b97497855937e57532c21668e8a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bc5908e9fe695282c253f15d96369dad2ce1d86f0387da08f74880303b97d22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03f972c333e11ecafdc315bef51d5c498d12cfe352fcbbc8a4bf19e2f68519e6"
    sha256 cellar: :any_skip_relocation, ventura:        "819f6ab634df1028bd2f87400f0eb3cfcc872e047f523bdd1ed0daf3314206ff"
    sha256 cellar: :any_skip_relocation, monterey:       "0f6c121d11f93b56cfffa4b075e1287b8b5bf4ef274de7ab136352574bb41f6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4af7b5d66e3db965c25eca7e1bd61441d09bd54dd3e1e2e4971f8ca4ce0030f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ccec5ac199179cf0787b9cfe48082ebbb26dc2f0f60630d5c127af8c1b30ca7"
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
