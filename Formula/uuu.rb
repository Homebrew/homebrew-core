class Uuu < Formula
  desc "Universal Update Utility, mfgtools 3.0. NXP I.MX Chip image deploy tools"
  homepage "https://github.com/NXPmicro/mfgtools"
  url "https://github.com/NXPmicro/mfgtools/releases/download/uuu_1.4.243/uuu_source-1.4.243.tar.gz"
  sha256 "9fcfe317c379be1e274aae34c19e1fd57188107f8fd0cdd379fe4473aacc92b1"
  license "BSD-3-Clause"
  head "https://github.com/NXPmicro/mfgtools.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/(?:uuu[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "6d98d5f7415a9a48212b6ceb9fca916ef5f389674af1226ea33deeed4fbf55db"
    sha256 arm64_big_sur:  "fcc082a046e5434ffbb0194ca0246b1a6eb331679ca00a3e67f934575f022089"
    sha256 monterey:       "6f282587da598660d96aad433ebc9537910ba5da6f768eacc96fe9ccd00db636"
    sha256 big_sur:        "2e71e4dc3c51ae85422dafb07c465b81936cd1a3608dd2a6f0e8d336f666f9f8"
    sha256 catalina:       "15485ecb8c573a08aa2de01a69b2c32c90607d71cf6efc506057771f56616246"
    sha256 x86_64_linux:   "d7d8dc25a86d910314416c59d985d6a6e3aa8028c0875be9868edf2cb6528a15"
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
