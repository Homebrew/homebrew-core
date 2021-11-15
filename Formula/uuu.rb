class Uuu < Formula
  desc "Universal Update Utility, mfgtools 3.0. NXP I.MX Chip image deploy tools"
  homepage "https://github.com/NXPmicro/mfgtools"
  url "https://github.com/NXPmicro/mfgtools/releases/download/uuu_1.4.165/uuu_source-1.4.165.tar.gz"
  sha256 "3b683f4c73eac4f6c7b918b7ad7a101276866b11b631355153962b4fd54ad19e"
  license "BSD-3-Clause"
  head "https://github.com/NXPmicro/mfgtools.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "56a412dd091e6e8f16eece2399fe09a6bb60f17f27b3cc9e7ba3a2fa831a1f32"
    sha256 arm64_big_sur:  "3155b7adc7452904671c7da18cbaa59766dfdd567e85a2b242c24cd8dfede40a"
    sha256 monterey:       "e05933d505e1ff45f462b6a45621166895816388efc4fed9a18a4b99f1d49081"
    sha256 big_sur:        "90095bd9997651cf9ae3a7b50fd4766968913f2652f2ce47a272ce84e3ce4277"
    sha256 catalina:       "a66ab4d8c2f44e2ed70106f45765591192b74726f6a1bb2e9e2475c3b9741a2d"
    sha256 x86_64_linux:   "174d6f56a091fc444337cf21fe0b69595ee87d6bf7da58da597f045bb053de3e"
  end

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
