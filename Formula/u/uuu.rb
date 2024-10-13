class Uuu < Formula
  desc "Universal Update Utility, mfgtools 3.0. NXP I.MX Chip image deploy tools"
  homepage "https://github.com/nxp-imx/mfgtools"
  url "https://github.com/nxp-imx/mfgtools/releases/download/uuu_1.5.182/uuu_source-uuu_1.5.182.tar.gz"
  sha256 "723d3da358e6af974a056e3adbcb105fac9dad4b87544de0d22b8c974a8037aa"
  license "BSD-3-Clause"
  head "https://github.com/nxp-imx/mfgtools.git", branch: "master"

  livecheck do
    url :stable
    regex(/(?:uuu[._-])?v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia:  "7bfe2010f69a821f75edc985e15696b22a8fcab1adf829d0da05b1ff88c7fe29"
    sha256 arm64_sonoma:   "2d0b798240aa95ac17d48010de1eacf4115b7cfbe3c30a216fee81ac52210716"
    sha256 arm64_ventura:  "be2915e1eb0d229e66cc94e18873863af4d23d04194a266e95850ba08435b7df"
    sha256 arm64_monterey: "ba7c3dd03436445bb5405d73d53c0631b323b5021fb845906009e24274c45f9b"
    sha256 sonoma:         "a77873946eb1b54f22f61e7d8f3a1d33fee09e72bcf50ec86f474532a5ac233b"
    sha256 ventura:        "7e06483006d74914e337b98add7df1a38e9f79cd97d3eb05695df5968f6dd9cf"
    sha256 monterey:       "50935214e4b33cf3d80dae31ec529e32e5c02ed4ef7efd86c45e87eb31faaa2d"
    sha256 x86_64_linux:   "19e6bebfc3fdb36ef5b0ee3c517e294c75a2ebc9460501a104c00d7586239616"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

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
