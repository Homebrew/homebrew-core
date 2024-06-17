class Zmap < Formula
  desc "Network scanner for Internet-wide network studies"
  homepage "https://zmap.io"
  url "https://github.com/zmap/zmap/archive/refs/tags/v4.1.1.tar.gz"
  sha256 "b37c4e70e4f9c12091ee10dc7f6f3518cbb7bc291b5b81a451a37632c9440047"
  license "Apache-2.0"
  head "https://github.com/zmap/zmap.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "e9f03756e05b6bd6055211bc3c680c7e6422f05544eabe3c462ccd62f4cd00b6"
    sha256 arm64_ventura:  "6fb686af14dca29842ccf0a77215baf561a3f41ffbc5cc90260f531cc826e0b4"
    sha256 arm64_monterey: "ea1b3672030301806e53512723c4c62c8c9e6f063e3f5f9720c15db76edd86bd"
    sha256 sonoma:         "ea802d444ef3e913eb5318ff5d577048a5212dbdb53bfe55665646d53c59ffe6"
    sha256 ventura:        "0c3ec340ec8f5a5a74ffefc1c94b6e32cecf560cbf1cea5e40777f169363cf6f"
    sha256 monterey:       "8e07fcf05542f8bd748a07daa4f7e05420b29ff450995936b00ba55ef4fece8b"
    sha256 x86_64_linux:   "89c9278354e1726ed6bda01e19c6f8830ce1a5e90965d71709e0e44414ae4d0c"
  end

  depends_on "byacc" => :build
  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "pkg-config" => :build
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
