class Subnetcalc < Formula
  desc "IPv4/IPv6 subnet calculator"
  homepage "https://www.nntb.no/~dreibh/subnetcalc/index.html"
  url "https://github.com/dreibh/subnetcalc/archive/refs/tags/subnetcalc-2.7.4.tar.gz"
  sha256 "05450353236b3a9cbbd24c1aa2fd866d770a7244874c978b764bf574600b433d"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/subnetcalc.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "eab7676292c5e1b9952d2c8d9424f93324be9c4fbd7da9a56e5b7377e54a8586"
    sha256 cellar: :any, arm64_sequoia: "f3f908facb153710f15143d210316a9b041fce82d50bff5328c7528787c7d54c"
    sha256 cellar: :any, arm64_sonoma:  "2f93bc9d82f8aa65b6f12e9e21396406045ee27cc65b6f2183a213324b84827c"
    sha256 cellar: :any, sonoma:        "bf6ec1fa2eca2db9d4e969f8daae6282439d71f8d06986818e8d895ce122987f"
    sha256 cellar: :any, arm64_linux:   "8e5804083196d938b856fcbcd174d1720500331b1dede92608377b86b8f8d2a8"
    sha256 cellar: :any, x86_64_linux:  "047951d059344c65edd14431d502458cd17160d8d889de1e36a4df1e89da774a"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "libidn2"
  depends_on "libmaxminddb"

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
      Host Bits      = 0
      Max. Hosts     = 1   (2^0 - 0)
      Host Range     = { 1.1.1.1 - 1.1.1.1 }
      Properties     = \

         - 1.1.1.1 is a HOST address in 1.1.1.1/32
         - Class A
      DNS Hostname   = one.one.one.one
    EOS
    assert_equal expected, shell_output("#{bin}/subnetcalc 1.1.1.1/32")
  end
end
