class Subnetcalc < Formula
  desc "IPv4/IPv6 subnet calculator"
  homepage "https://www.nntb.no/~dreibh/subnetcalc/index.html"
  url "https://github.com/dreibh/subnetcalc/archive/refs/tags/subnetcalc-2.5.1.tar.gz"
  sha256 "c7257ca02518e863bf15042f7f88a70cae847917f333dc5dc17b7ccc6fc48000"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/subnetcalc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f412e72a2c7b247d83909cb660fc3595ec90c7d3b04a1d781553f6c4a1cb9420"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c68d8d3458b1880d69912904cf05fdac23daff520ff49d5c9b3c57dfb32c3c49"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5faea6c8efcb60fe3982b9f40d025a84665e1add0a2911eff15c6155c5d8fb2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa4e3a5bdcbfa06cd3887dfac1ed33fe914567aabed4cf32631dce70a9d7795e"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa8ad8d4b785ae31383188aaf2f22b550042adc174b1a34f04d9f149a6ce80f0"
    sha256 cellar: :any_skip_relocation, ventura:        "d780d4de85adbefd23f805d9e1869795cb0ed3860ccba27276a678d30ba15ed2"
    sha256 cellar: :any_skip_relocation, monterey:       "86da62090befa393bb27f39c47f2c7ad9bf67331690aa5137e81aec72ddfca3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49e4fdb4ac568c15b7f6c17c8618dc52f49e01f21eba1211b109fd6982b05677"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    expected = <<~EOS
      Address       = 1.1.1.1
                         \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m . \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m . \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m . \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m
      Network       = 1.1.1.1 / 32
      Netmask       = 255.255.255.255
      Broadcast     = not needed on Point-to-Point links
      Wildcard Mask = 0.0.0.0
      Hex. Address  = 01010101
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
