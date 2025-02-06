class Zmap < Formula
  desc "Network scanner for Internet-wide network studies"
  homepage "https://zmap.io"
  url "https://github.com/zmap/zmap/archive/refs/tags/v4.3.2.tar.gz"
  sha256 "2f1e031d07d9c7040bf75aa58e258c311985e2b32dbb9a375e0d1c31bcedbf0a"
  license "Apache-2.0"
  head "https://github.com/zmap/zmap.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "d326a34265c555a0e1fa70ff50d863bd5be082f8108a967129a84aac1c52641a"
    sha256 arm64_sonoma:  "aefe7a1d975eb0a86737dbfaff6362018b6599795011fd5412940b650bab5e35"
    sha256 arm64_ventura: "6f6b3a6a443ed8e5e0599b80635df6457d691fd519b7cfb20efe10d5475d84c4"
    sha256 sonoma:        "4071a54bda62907d58be4a07eac8db28c134be4952f7b3bad0257151785c2298"
    sha256 ventura:       "20fc280d37b9e11f2d24510ebd0ba8edc3f6e710383973b3e46bc8082bca6036"
    sha256 x86_64_linux:  "4d0ae017c4e6bcb5d3cb6c076307a989489ab76bfb7cc5f038b8ba55f11f5e12"
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
