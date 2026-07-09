class Zmap < Formula
  desc "Network scanner for Internet-wide network studies"
  homepage "https://zmap.io"
  url "https://github.com/zmap/zmap/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "be4521fdac10eddc9ba046399149064ca23d4630b7987301abdee9e0044b8d5c"
  license "Apache-2.0"
  head "https://github.com/zmap/zmap.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "a6cfcbd2423f57bffb1699a0c540e1d56104e515badf2c5e57db18b281b18bcf"
    sha256 arm64_sequoia: "aef2c085a16b8ff137a8b4a9686a3f84f5d0ceff85e26c15c6123b477e605550"
    sha256 arm64_sonoma:  "c1a2bc3e2e68b40a000b190d3717878c7d47d7d6498bb55a9414ae2e053b8659"
    sha256 sonoma:        "0825eeed6ad930f164a7706e2dcdd83a9d61b7368b2d16577a3d7b10cc214dc0"
    sha256 arm64_linux:   "fd9772f29689341c0e65fbb720dbb8b019379f4db80d2596eeedfa1490879d07"
    sha256 x86_64_linux:  "44aae53bcb568d3bfe6926c09768e9fa9a03b5aed700e8279d3ac95f59354469"
  end

  depends_on "byacc" => :build
  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "json-c"
  depends_on "judy"
  depends_on "libdnet"
  depends_on "libunistring" # for unistr.h

  uses_from_macos "flex" => :build
  uses_from_macos "libpcap"

  def install
    inreplace ["conf/zmap.conf", "src/constants.h", "src/zopt.ggo.in"], "/etc", etc
    args = %w[-DENABLE_DEVELOPMENT=OFF -DRESPECT_INSTALL_PREFIX_CONFIG=ON]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{sbin}/zmap -p 80 -N 1 8.8.8.8 2>&1", 1)
    assert_match "[INFO] zmap: By default, ZMap will output the unique IP addresses " \
                 "of hosts that respond successfully (e.g., SYN-ACK packet)", output
    # need sudo permission
    assert_match "[FATAL] recv: could not open device", output

    system sbin/"zmap", "--version"
  end
end
