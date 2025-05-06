class Zmap < Formula
  desc "Network scanner for Internet-wide network studies"
  homepage "https://zmap.io"
  url "https://github.com/zmap/zmap/archive/refs/tags/v4.3.3.tar.gz"
  sha256 "1a14b5d560d1c931528104d644ae033f4f874a21f67f9e6d04f7173e413561ec"
  license "Apache-2.0"
  head "https://github.com/zmap/zmap.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "6f46e4e52386e58a63a67a8882fa4bda0e4a78132e60e48c6e3996740ceb9387"
    sha256 arm64_sonoma:  "1bd4fd2dafafc9e03263cf85b2e07140643c16bdb1aab8ee2283ceeeb716942c"
    sha256 arm64_ventura: "7141b33f32eabd728c35914900704f7921cc8d9e37b61b8d074d7dcf7b320e8c"
    sha256 sonoma:        "da2626616b8f96ac3725b2ebd871d815cf6237a591c23c378cf1ec0a7095b45b"
    sha256 ventura:       "619fc270bcdedeeea2a309573b8201a64eb45fde9cd9f15fd7a9ac278b2f8db1"
    sha256 arm64_linux:   "88cb07089110183f13032bce79cdbe1646cee5cc60cd3da6378be24abf44eac9"
    sha256 x86_64_linux:  "f2c331f1a92fe6c1ea445d7bbc1781cde0eb89bb06ff5e7d056c8c5e20d1f5f1"
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
    inreplace "CMakeLists.txt", "set(ZMAP_VERSION DEVELOPMENT)", "set(ZMAP_VERSION #{version})"
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
