class Uuu < Formula
  desc "Universal Update Utility, mfgtools 3.0. NXP I.MX Chip image deploy tools"
  homepage "https://github.com/nxp-imx/mfgtools"
  url "https://github.com/nxp-imx/mfgtools/releases/download/uuu_1.5.243/uuu_source-uuu_1.5.243.tar.gz"
  sha256 "dee3be0f337c631bf93232f5ea42440f07782ce005c9219a14731d66bbe83658"
  license "BSD-3-Clause"
  head "https://github.com/nxp-imx/mfgtools.git", branch: "master"

  livecheck do
    url :stable
    regex(/(?:uuu[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "4647654b18285ec907a87f85da36b8ec63cf7c22836f45815c0a0ceacf1f8e36"
    sha256 arm64_sequoia: "b40e7e680e9d7e1b2f416e2e6e1c7c1c4ecf04a30ec1744da19119dd1b570634"
    sha256 arm64_sonoma:  "89a11b1316b94142eba3efa3286dde5384fcec4710f8000e7105b1a8dcdb2fea"
    sha256 sonoma:        "2fd66ee2db00c408a5d62a0cf3ec3d8dd6db445057e9fe11bddb56ba0e7a22da"
    sha256 arm64_linux:   "129e2c8078ebe4f17a6536b26784fcf149994cb8a16643f2027c640341dc67fe"
    sha256 x86_64_linux:  "f3cbcdd779051e500329b6588600fc0241667164281d8361bbc0c0bec95ddf38"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "libusb"
  depends_on "libzip"
  depends_on "openssl@3"
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
