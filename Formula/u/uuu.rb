class Uuu < Formula
  desc "Universal Update Utility, mfgtools 3.0. NXP I.MX Chip image deploy tools"
  homepage "https://github.com/NXPmicro/mfgtools"
  url "https://github.com/NXPmicro/mfgtools/releases/download/uuu_1.5.21/uuu_source-1.5.21.tar.gz"
  sha256 "600be50827b52df4dddf0c7d07da27b103a4576eb445890905c61780e3c36871"
  license "BSD-3-Clause"
  head "https://github.com/NXPmicro/mfgtools.git", branch: "master"

  livecheck do
    url :stable
    regex(/(?:uuu[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "1eb20a07cb86eb051cd95d37bf75f7414570ae840be6b282ee861f1c31b8471c"
    sha256 arm64_ventura:  "58dd8bc829701d49085faadf208e43bd869109ba5d4d27cde7995a28e7b6135d"
    sha256 arm64_monterey: "992d11add364fc514b701aaa73b8c125bf0dcc93604b6cd2f2f6a4ddb3f563dc"
    sha256 sonoma:         "fbd6db07987978cff6931e9fb0ddc0808db6183a04909829273b7c4d08da896d"
    sha256 ventura:        "59f77ff7c20474c5c14b0b5d9852ce2258afa09a2c96b52538319d39f0941667"
    sha256 monterey:       "b6731c0e461f661b702a40252d2025816ca661257caae55d4030c357de1cb858"
    sha256 x86_64_linux:   "c16227ec537e42c55cb3dfde5ab29b7aac87c93ad10e4d61f9dedf6caa6f2081"
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
