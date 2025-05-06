class Subnetcalc < Formula
  desc "IPv4/IPv6 subnet calculator"
  homepage "https://www.nntb.no/~dreibh/subnetcalc/index.html"
  url "https://github.com/dreibh/subnetcalc/archive/refs/tags/subnetcalc-2.6.4.tar.gz"
  sha256 "0730855c8b619e4a6237882e0bd12c2220285a12b7b869e1193b0f92e189a262"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/subnetcalc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fabdbeae955ea728d9eae0de44710cbee5e16cf43ba6cae647d4dad0b0450f08"
    sha256 cellar: :any,                 arm64_sonoma:  "1790982a2d3245a83958803257775f56fb37b0f3b11110a861c851221570ee8c"
    sha256 cellar: :any,                 arm64_ventura: "5dcaf2b58612c6fe992e7d601330d019df0d96db3a30763c6d81e7d33079158c"
    sha256 cellar: :any,                 sonoma:        "832a61d27689832f65aee4517107e046a182aff53037dba7c2e205dfb4031d37"
    sha256 cellar: :any,                 ventura:       "52413178955b01a026648bac5e4af714666911cdab595f669b380392255369e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b7cc635edd10a32dcc9922495890a2381735eb4662e04e8437b31dd9bf9b8ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7790fc9a8581bd12c61062ad16595fded5b17506bc4faf1777a033b50391f806"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build

  on_macos do
    depends_on "gettext"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    expected = <<~EOS
      Address        = 1.1.1.1
                          \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m . \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m . \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m . \e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m0\e[0m\e[34m1\e[0m
      Network        = 1.1.1.1 / 32
      Netmask        = 255.255.255.255
      Broadcast      = not needed on Point-to-Point links
      Wildcard Mask  = 0.0.0.0
      Hex. Address   = 01010101
      Hosts Bits     = 0
      Max. Hosts     = 1   (2^0 - 0)
      Host Range     = { 1.1.1.1 - 1.1.1.1 }
      Properties     = \

         - 1.1.1.1 is a HOST address in 1.1.1.1/32
         - Class A
      Performing reverse DNS lookup ...\r\e[KDNS Hostname   = one.one.one.one
    EOS
    assert_equal expected, shell_output("#{bin}/subnetcalc 1.1.1.1/32")
  end
end
