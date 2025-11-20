class Uuu < Formula
  desc "Universal Update Utility, mfgtools 3.0. NXP I.MX Chip image deploy tools"
  homepage "https://github.com/nxp-imx/mfgtools"
  url "https://github.com/nxp-imx/mfgtools/releases/download/uuu_1.5.233/uuu_source-uuu_1.5.233.tar.gz"
  sha256 "aadd7edb9494fe1768f7d2964aa470931da15bd83f82a1829d786f8ec80ca169"
  license "BSD-3-Clause"
  head "https://github.com/nxp-imx/mfgtools.git", branch: "master"

  livecheck do
    url :stable
    regex(/(?:uuu[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "ce0b40eea128f2b48db0fd6774aec7092a6ea3963e550ed24693ae7880f57f88"
    sha256 arm64_sequoia: "4245cc4bce944ca7a491acf2fc47a5e2a1456a2214fa55fd18a6ece6d256cd96"
    sha256 arm64_sonoma:  "b728f8450fb548522cd18d4260ec23ec7b44bf7e5bb53490572b49ca0e59909d"
    sha256 sonoma:        "d10283c4a4c6ecfd601e1de144ed2cda03c172c93bef91297d7adc4af4e4c192"
    sha256 arm64_linux:   "7613cc30f2213d659f9e58bdabc761f24f92afc2e35ed65b18dc963c509976e4"
    sha256 x86_64_linux:  "50643dd422b69cd0ab474e224c82395e9f7d3298bf6b82685a6736545012584b"
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
