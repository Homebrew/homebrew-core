class Zmap < Formula
  desc "Network scanner for Internet-wide network studies"
  homepage "https://zmap.io"
  url "https://github.com/zmap/zmap/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "2580e41fbb56b7576530b2cdcac6dd6b5e167197a6981e330d56cfb14b3d3ebf"
  license "Apache-2.0"
  head "https://github.com/zmap/zmap.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia:  "9dd056e4d7ffd52f2cdc9693b6276c793e7b53c115162a5d3dde6fa247418bd5"
    sha256 arm64_sonoma:   "2afb958e5cf1195c4b0abaf02499c47657f80ae9e0ae024cc5ac5735b8a19b49"
    sha256 arm64_ventura:  "0915eb108a040ac4521bff1c3bf74d7dbe5fdd50562c54ba577134e2a25e89c4"
    sha256 arm64_monterey: "f87110cb0e2f53d0935111b38a9e7b575a471b951427822bb1d26ec622c7eae4"
    sha256 sonoma:         "9890a9e03db22305f92d73e61a2c446d351b7bbbff84cadaaeb769c617bc240e"
    sha256 ventura:        "447689ffb2bd5945168ce33f58e45ef25d815bc7849af63f03a189cb4ae3e7c9"
    sha256 monterey:       "97bfc7b9a702b867cc6a27e00d931d28abeb4f5022e41c2e19d3ef6b190f9d25"
    sha256 x86_64_linux:   "b60d5bcdec61a77e710f6803fa4fea8d77e16df4ff75615f03c919898c385dbb"
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
