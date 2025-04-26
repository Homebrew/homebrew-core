class Subnetcalc < Formula
  desc "IPv4/IPv6 subnet calculator"
  homepage "https://www.nntb.no/~dreibh/subnetcalc/index.html"
  url "https://github.com/dreibh/subnetcalc/archive/refs/tags/subnetcalc-2.6.3.tar.gz"
  sha256 "2b74c2fdea7f664c3e05b488bbb4835af6ba1d692298bb762d4f5176e63e042f"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/subnetcalc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "138f87c18cda74e33e4147f21b0357cf7a374cde9f95146143798ecfcca2b7ad"
    sha256 cellar: :any,                 arm64_sonoma:  "a9a3f33ee75773abbcd3dbac9ede76a811dcca7b060183653879a3048e0684bc"
    sha256 cellar: :any,                 arm64_ventura: "d8533124aabc2a25b5018f16df0288d8adb979c89c36876b4c22a9674697ea88"
    sha256 cellar: :any,                 sonoma:        "08bd48a0f98d5cf81505e1906d41c9db71dd76b9c93e89734ff3f1c69009a74e"
    sha256 cellar: :any,                 ventura:       "26a3806b54909366ffa408c3c46b5b2be510b80efc045c9418f11a882b9a1574"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba4c0ab90ce5bd781a67575556515da96cc33f7276ff27db040d37bef8442022"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01ac463586d09aa3f931b9959bfae57f5577cdfd48707a80f11835770695de6e"
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
