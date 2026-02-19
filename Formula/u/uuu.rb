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
    rebuild 1
    sha256 arm64_tahoe:   "781cf15e04977227c875bee8a775a9a467e7637f5b5b66ed5348ca21ffd77d4c"
    sha256 arm64_sequoia: "1f7d083fb0a660d6ae993992f57ad7e06f419dc1fd6701ef4e774ddcfa27e76a"
    sha256 arm64_sonoma:  "8fd6cc628b1828bda6849151bc7214163809369e23f0bef838e077639915b62f"
    sha256 sonoma:        "22b6cffa3305490a93fdff5c2cb6b181245507da7d1fc4ce1fcdf8927b18d42a"
    sha256 arm64_linux:   "727d2f61c7d555622887421a49e839ec1186aa19f82a62c3d6d6b710252e6862"
    sha256 x86_64_linux:  "bcddad7081ccf91f1d525ab5ec6602033c15e7f0e673f82fb45c076fae8af1ca"
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
