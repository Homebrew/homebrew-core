class Uuu < Formula
  desc "Universal Update Utility, mfgtools 3.0. NXP I.MX Chip image deploy tools"
  homepage "https://github.com/NXPmicro/mfgtools"
  url "https://github.com/NXPmicro/mfgtools/releases/download/uuu_1.4.193/uuu_source-1.4.193.tar.gz"
  sha256 "a9b8b74e32e6718d591c66951b8b52276df7862db80ee943e046947f7313e57f"
  license "BSD-3-Clause"
  head "https://github.com/NXPmicro/mfgtools.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/(?:uuu[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "a44aa408d7a07a11cbeb20c642dd276b51eb4574858d1a7479df0e180126e33b"
    sha256 arm64_big_sur:  "bdf2b936c008aaf09c4a2f819a3c030beb51097aef6f7b29963d03ef885b1de8"
    sha256 monterey:       "f5b631847fc6d9339e73639d94f44f54ffd7e8f53c766372efdcdc5aa7ba3028"
    sha256 big_sur:        "2b5b9e290dea1d298e8fda32f7c9cb31866a58603ebd372073e38a8434afe863"
    sha256 catalina:       "c5bf3f74dd5c610b5a340bced3b71fd18af0b6972cb7491e431b793224d46fac"
    sha256 x86_64_linux:   "27bf7f8fcb8200129bc7a01b6450e548bac6449ddc4660a1dc5929740f5ebf73"
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
