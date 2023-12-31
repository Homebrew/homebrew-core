class Subnetcalc < Formula
  desc "IPv4/IPv6 subnet calculator"
  homepage "https://www.nntb.no/~dreibh/subnetcalc/index.html"
  url "https://github.com/dreibh/subnetcalc/archive/refs/tags/subnetcalc-2.4.23.tar.gz"
  sha256 "cbfdcc54991cacb91adc652cb5f03b3ed975da0f574ff3f96f192c6046dc0e34"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/subnetcalc.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48e6ddafc3e3ec5a398c0d7fa0d2da5ce205dd5d65adf7264037a52bc1be2fdd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c23e94c5393dbff89beb8183c27617d3d60506ae2a917cfead0acbe9d359e00e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e8f04b4b36f2cce4c87c8f89ea785154a92ef34910ef6e3300b67525f78b9d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "92b125e3c6753bc2ded7ae2d372bfd883597d916f9bdfe79a1f66e345fb814b6"
    sha256 cellar: :any_skip_relocation, ventura:        "3c8061b49a179ea98fe6087e9b4cda6006168bebcd1e9fa9b84bb96b1e2dc54f"
    sha256 cellar: :any_skip_relocation, monterey:       "b72f1faf131c21d490e193d079b0dfa822de569ff815acca5cdb5722acdfa8e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1582ddde342d5e7b02f1cc26266843aeb736a1abee8a1a08af2bf567ba6ed05"
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
