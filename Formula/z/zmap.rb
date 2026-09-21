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
    rebuild 1
    sha256 arm64_golden_gate: "0395a8921d0d23d1022233a1cf2a8b7fbdd2d83da35611ce26c199d4fd4578dd"
    sha256 arm64_tahoe:       "a78dfb358782c21ebc754ce63d0d54b80d274b7f73b2f5f3fe9c8fcd04972c3d"
    sha256 arm64_sequoia:     "06ed1558ae552a5e77602d41086a4e25d3d6eaa03615a7e850db885d817f29e4"
    sha256 arm64_linux:       "73720cfee6360c4a420f4cf12e9a8b3fee89faf598e47de1cb7a68fa548360b6"
    sha256 x86_64_linux:      "b7a2feb5a7e0ace72f678517b0dae749f9f02fdb4b4f7ca2ecacc9f376096119"
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

  deny_network_access!

  def install
    inreplace ["conf/zmap.conf", "src/constants.h", "src/zopt.ggo.in"], "/etc", etc
    args = %w[-DENABLE_DEVELOPMENT=OFF -DRESPECT_INSTALL_PREFIX_CONFIG=ON]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Pass a gateway MAC so the test does not depend on the host's ARP table
    output = shell_output("#{sbin}/zmap -p 80 -N 1 -G 00:11:22:33:44:55 8.8.8.8 2>&1", 1)
    assert_match "[INFO] zmap: By default, ZMap will output the unique IP addresses " \
                 "of hosts that respond successfully (e.g., SYN-ACK packet)", output
    # need sudo permission
    assert_match "[FATAL] recv: could not open device", output

    system sbin/"zmap", "--version"
  end
end
