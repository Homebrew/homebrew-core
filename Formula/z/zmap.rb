class Zmap < Formula
  desc "Network scanner for Internet-wide network studies"
  homepage "https://zmap.io"
  url "https://github.com/zmap/zmap/archive/refs/tags/v4.3.4.tar.gz"
  sha256 "b5936bf5b5390fb50203140e81beac28866374371b1c68329cbbe932cc5ee1d3"
  license "Apache-2.0"
  head "https://github.com/zmap/zmap.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "0f8b31f9fcda17ba66605ca6761f8497ef1217b3ecc8d31d8cdd8af8ce8b7357"
    sha256 arm64_sequoia: "297abfb8c655871cda8e7957710c352f4010c09ec19adb07bea3c4b235fdd957"
    sha256 arm64_sonoma:  "45170d73fe6d3ae15919833d77f9c30ceff889e44dd40bf293f5bd6df4418ab8"
    sha256 arm64_ventura: "c3628c8ae1ae1bb500fe770668a61b4be782a5e659a68c8cf3ec238c4e22f35e"
    sha256 sonoma:        "daefd0ba4f61064f028ded544912b684c1b0c399a81b4f99b8ba45af4fd5fa80"
    sha256 ventura:       "d96bdbf89a92db63caa5c453ad350a470d32cc1c3d2bf0ccc5d6c56d20911018"
    sha256 arm64_linux:   "7282a45a8902c4e6a32797d7001c24f6c6d3d0e928d3cb1f1e32a6dd4953d470"
    sha256 x86_64_linux:  "39f86237f9e1c880b41751e79f3407e9614a1ba7aba5db2d06268d7d08323b3d"
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
