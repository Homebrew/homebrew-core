class Zmap < Formula
  desc "Network scanner for Internet-wide network studies"
  homepage "https://zmap.io"
  url "https://github.com/zmap/zmap/archive/refs/tags/v4.3.1.tar.gz"
  sha256 "a281eaeac415f49734e22f9219e36454843de494ab8f9723a3de7f123142050f"
  license "Apache-2.0"
  head "https://github.com/zmap/zmap.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "214e3c5e737f7e24e43a862d6a406783a26849dfce5397968d1f82f271916011"
    sha256 arm64_sonoma:  "e9a052baa17629a915d316f4c60ecdc0bc74d4053aa2170274ca6cff52938b01"
    sha256 arm64_ventura: "1c9c999c1502428fb651060fcf141e99c4f0ad9a543486a7b0f8ca638bca47da"
    sha256 sonoma:        "c55f89e68237932793dd1b797d69bcaf31de04f7bcdb56e9f843bcdf0a284fd2"
    sha256 ventura:       "5b17c50001640bb28f32f894aa24669d399d721bdabdfbaf5e722e4b1e40c345"
    sha256 x86_64_linux:  "551d0ecdb223d03ae41d02350daccacca6863cd169895621e63b299bcca3f380"
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
