class Subnetcalc < Formula
  desc "IPv4/IPv6 subnet calculator"
  homepage "https://www.nntb.no/~dreibh/subnetcalc/index.html"
  url "https://github.com/dreibh/subnetcalc/archive/refs/tags/subnetcalc-2.6.5.tar.gz"
  sha256 "d3ca16b75b4eced6e4196b9791f9514941eaa9bcdaa2a899fbcc0b845103f097"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/subnetcalc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d7923eaa0a2d183a02618bfb1cfac211e9dac6040597d28a3f4d4c8af3fba80d"
    sha256 cellar: :any,                 arm64_sequoia: "e0c0d392a6d5fa27cd2207b26d8b1c376359e0738b63cffa5ae2951ee0e2c03e"
    sha256 cellar: :any,                 arm64_sonoma:  "44199b26e469f3c20fd1f2de74d867e02d7ea2d2db4fec8ad9ac765b55a62035"
    sha256 cellar: :any,                 sonoma:        "60e77cc0cd0d150a3169f0706466f62a5af2af28d3394ad582ddb44307bcf723"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "944e9791235a7515960ec89f50c2fdd837506fea80ea544a24b4cc7a1c47c51d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8051458c3e893d302194e119a105cefbefc848ede22667da8dd39d97cfefeb02"
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
