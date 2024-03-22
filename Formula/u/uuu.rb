class Uuu < Formula
  desc "Universal Update Utility, mfgtools 3.0. NXP I.MX Chip image deploy tools"
  homepage "https://github.com/nxp-imx/mfgtools"
  url "https://github.com/nxp-imx/mfgtools/releases/download/uuu_1.5.125/uuu_source-uuu_1.5.125.tar.gz"
  sha256 "085d7f6308ee6b77dfb131fac40704575525adf6da45cdc446c00a0b29e4c21a"
  license "BSD-3-Clause"
  head "https://github.com/nxp-imx/mfgtools.git", branch: "master"

  livecheck do
    url :stable
    regex(/(?:uuu[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "842f691b7008044ea148fe7eef2523c9ba7b3605b180afae67a3f7e999917dc6"
    sha256 arm64_ventura:  "0ba2aebd7f7f39b0d9df102ce95051c4adab45a4833a2eeef82d05559ca24371"
    sha256 arm64_monterey: "11fd2b6a778f22dd94a65c726dcd1bf0c3c67ee54588ad56145bbee562e717af"
    sha256 sonoma:         "af7f755a7bfaf7806fe495f0dac19c0d5d0f6da710367218ea4ac6aa2adf5feb"
    sha256 ventura:        "7025c7bf54ac4d3226df3d89de5f59ad2a5d66017b5d6f00b82298bbc1ef08a9"
    sha256 monterey:       "bc28bec39757b22282a1ae4434135250b2a28bde0c27f3617f407d321151faa9"
    sha256 x86_64_linux:   "5fd35e71f42c6723b10763e61957955946379f9e7da4092ca4207a6f7c9c5064"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "libusb"
  depends_on "libzip"
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "Universal Update Utility", shell_output("#{bin}/uuu -h")

    cmd_result = shell_output("#{bin}/uuu -dry FB: ucmd setenv fastboot_buffer ${loadaddr}")
    assert_match "Wait for Known USB Device Appear", cmd_result
    assert_match "Start Cmd:FB: ucmd setenv fastboot_buffer", cmd_result
    assert_match "Okay", cmd_result
  end
end
