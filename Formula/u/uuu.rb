class Uuu < Formula
  desc "Universal Update Utility, mfgtools 3.0. NXP I.MX Chip image deploy tools"
  homepage "https://github.com/nxp-imx/mfgtools"
  url "https://github.com/nxp-imx/mfgtools/releases/download/uuu_1.5.243/uuu_source-uuu_1.5.243.tar.gz"
  sha256 "dee3be0f337c631bf93232f5ea42440f07782ce005c9219a14731d66bbe83658"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/nxp-imx/mfgtools.git", branch: "master"

  livecheck do
    url :stable
    regex(/(?:uuu[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "cfba502f9184d051f13623d2c88669ece9028fcd852bb68c81d5fccc4b0dd838"
    sha256 arm64_tahoe:       "383cb763767f508e112b6bd619e81a4b6779b1b1068e4321a10388f924f5f1bf"
    sha256 arm64_sequoia:     "2e85d56d8536dc2b0e21e19aca7c04a3897b68bc09cf0af84358a4acea1a28ed"
    sha256 arm64_linux:       "079a7c4fdab45b3e6fc32c3916b3b08272ce0f90ebed2a4c7f29cf91fdc28986"
    sha256 x86_64_linux:      "16efd6cdeed716671e490ceee4c5e273b24c40dd60dba810750f53f73a3eab59"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "libusb"
  depends_on "openssl@4"
  depends_on "tinyxml2"
  depends_on "zstd"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
