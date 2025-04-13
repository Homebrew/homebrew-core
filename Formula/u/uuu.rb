class Uuu < Formula
  desc "Universal Update Utility, mfgtools 3.0. NXP I.MX Chip image deploy tools"
  homepage "https://github.com/nxp-imx/mfgtools"
  url "https://github.com/nxp-imx/mfgtools/releases/download/uuu_1.5.201/uuu_source-uuu_1.5.201.tar.gz"
  sha256 "c763b87ffdf10ac5499a0c319463759caa336bc6567b56d6d0ef448590c1a76d"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/nxp-imx/mfgtools.git", branch: "master"

  livecheck do
    url :stable
    regex(/(?:uuu[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "d0dc183bd58f476ccf616ecb35d4b96a95e345859da2adea6c50ecaafb3c482c"
    sha256 arm64_sonoma:  "cee3bc7e87a0a6554789ce3545c6254f1ddd99b74fa4958bd1e63611b7b4a52e"
    sha256 arm64_ventura: "040d1ce65a6874b5cb49fff2b1ea0117e088a6432a50757750ee4ee71a03a695"
    sha256 sonoma:        "c53b10c409834bb554170339dff52cbb948c7aa1a5a8f895b29c99f60dbf2dd3"
    sha256 ventura:       "a0dc155bb4e5404c93e4d7fc492876367c3776d6120d0c04201f9258e438656e"
    sha256 arm64_linux:   "3ad4106bf0c1f97dd53645f7d4e60c7f17352169cd67e1a25a9bc6ff75aeb3cc"
    sha256 x86_64_linux:  "4aa91b9b65de6c00a02e2d6d5922521da22633139829b348f1186296225e348c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "libusb"
  depends_on "libzip"
  depends_on "openssl@3"
  depends_on "tinyxml2"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  # cmake 4.0 build patch, upstream pr ref, https://github.com/nxp-imx/mfgtools/pull/467
  patch do
    url "https://github.com/nxp-imx/mfgtools/commit/2c712cb86478a3527145272f0cc96533f9386b7a.patch?full_index=1"
    sha256 "220fd4a7d9f1abe957e621da486eabe6c8a35e61d4c3e6c5f54bcedcf0e13ed0"
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
