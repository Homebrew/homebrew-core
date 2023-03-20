class Uuu < Formula
  desc "Universal Update Utility, mfgtools 3.0. NXP I.MX Chip image deploy tools"
  homepage "https://github.com/NXPmicro/mfgtools"
  url "https://github.com/NXPmicro/mfgtools/releases/download/uuu_1.5.21/uuu_source-1.5.21.tar.gz"
  sha256 "e89d3665af499ab71360d948176cf64619b082f8272a994d1fbfc000e67c0f14"
  license "BSD-3-Clause"
  head "https://github.com/NXPmicro/mfgtools.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/(?:uuu[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "e13a2b32c07ba4a37b105ba11005ef441af6ab12c9f14c35f639eba205a282dd"
    sha256 arm64_monterey: "764c2c55a738f4c735f08796bd806769b5c04f22d63d4fbc954436ca8f528aa4"
    sha256 arm64_big_sur:  "0e139f269042a96f3dec0fdcba77901288aa0076156f29c409ad82d1ad0a4dd1"
    sha256 ventura:        "8aa2876a1425782f0f2f0416f608d50e40ee0dd7364a1de00e1e0a713af930dd"
    sha256 monterey:       "3cb5096a3e79451f8295bf2d48f294073673e3559becbdd923858f4da7c10337"
    sha256 big_sur:        "e9ce4cccfce96d7e18d358fbbf4acfa346d95ff79f28a78f6a18f835ffef196c"
    sha256 x86_64_linux:   "7ab6929cdcdf23fd790d5acd4637917e2498b2c776af76fcaec6ec2903d87444"
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
