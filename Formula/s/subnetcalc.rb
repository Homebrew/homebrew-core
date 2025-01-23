class Subnetcalc < Formula
  desc "IPv4/IPv6 subnet calculator"
  homepage "https://www.nntb.no/~dreibh/subnetcalc/index.html"
  url "https://github.com/dreibh/subnetcalc/archive/refs/tags/subnetcalc-2.6.2.tar.gz"
  sha256 "86f19e25b6bc61acd87bd0a6c36eeca1ba3d5710f5b99d047d74e719b83b3daa"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/subnetcalc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "82e699f797b2e36523bfbde9f984efa7a4f389a97cacc4ceafa693a468fe9186"
    sha256 cellar: :any,                 arm64_sonoma:  "c499df5030a705ba8ee61dfac09f57aef83e3f96cf097726de8ab70f3d30f31e"
    sha256 cellar: :any,                 arm64_ventura: "58d33d69ea03aa071f886e17844195c353e5fa0097f0dc151b065585beb2a2b6"
    sha256 cellar: :any,                 sonoma:        "aa856ed114bf797b86b9969b98b16ab1f80d127b2ee346cd923f66b40c2c9dcd"
    sha256 cellar: :any,                 ventura:       "20b90b6a8187f41c8b0e32983fabea0cefe05ee8434e1453efacc152280468df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5754d5860222151455f2b01d10005d2d38635c83c8fb9f093655e00e8f493cc3"
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
