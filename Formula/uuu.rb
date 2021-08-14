class Uuu < Formula
  desc "Universal Update Utility, mfgtools 3.0. NXP I.MX Chip image deploy tools"
  homepage "https://github.com/NXPmicro/mfgtools"
  url "https://github.com/NXPmicro/mfgtools/releases/download/uuu_1.4.165/uuu_source-1.4.165.tar.gz"
  sha256 "3b683f4c73eac4f6c7b918b7ad7a101276866b11b631355153962b4fd54ad19e"
  license "BSD-3-Clause"
  head "https://github.com/NXPmicro/mfgtools.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "libusb"
  depends_on "libzip"
  depends_on "openssl@1.1"

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
