class Uuu < Formula
  desc "Universal Update Utility, mfgtools 3.0. NXP I.MX Chip image deploy tools"
  homepage "https://github.com/nxp-imx/mfgtools"
  url "https://github.com/nxp-imx/mfgtools/releases/download/uuu_1.5.165/uuu_source-uuu_1.5.165.tar.gz"
  sha256 "6e65fc028afacc94b805ae376e3da3864dcb2570d425037820e716207ab70373"
  license "BSD-3-Clause"
  head "https://github.com/nxp-imx/mfgtools.git", branch: "master"

  livecheck do
    url :stable
    regex(/(?:uuu[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "e26b02f6b271d87ee60387fd0eb726cf6c624cbca415725b0087d3ceccba23bc"
    sha256 arm64_ventura:  "ab874bca6b934143c5409c656e6e7cfe6d27bfc82fb101ec30fe49242516df17"
    sha256 arm64_monterey: "b535f71ca4c12ed04438fd18c27f3754ab9565cb61b9d50f6f54e67592981478"
    sha256 sonoma:         "36d8243d8275559a4da10f0d759dfbfffbf53375629224a97769345e6a6f5c68"
    sha256 ventura:        "827238dcad512a10007edb815e07c3e7830d2c3fc1229e7f7ad88e5e06babae9"
    sha256 monterey:       "3352a6cb1824a2e08c0bc784581ffb09c3f32f1b74b914883fc16e18e5139a32"
    sha256 x86_64_linux:   "ba0ed7b39b8f20b0c7e513bdb9ec63e0c8233bb3aa5d9dc8d6857fab8ab7cf49"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "libusb"
  depends_on "libzip"
  depends_on "openssl@3"
  depends_on "tinyxml2"

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
