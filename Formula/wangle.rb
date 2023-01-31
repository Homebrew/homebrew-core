class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2023.01.30.00/wangle-v2023.01.30.00.tar.gz"
  sha256 "03e981ffca04aa11605eb129a9a1efdf4fd0828ac83b814852ca8caf3b8694fa"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1c7f0d761cdaff886ceb114ca79f0bac85439c87ed58434f74c3fce591b745cb"
    sha256 cellar: :any,                 arm64_monterey: "1cd1de8e84ef589347fd1097d64afd6832edea9eca78a8f9a6c0b946691521fb"
    sha256 cellar: :any,                 arm64_big_sur:  "d831299add0931a4f3de665aeeb1204ac76257333f941109d1d5a3ef394d0734"
    sha256 cellar: :any,                 ventura:        "71ef30fad23a2391e745ae4d9d6f797fd8d5ed42af18f91a2d84a424aa95d43a"
    sha256 cellar: :any,                 monterey:       "3429860e7557d83564b2c958e873892ea421a11eff38f39f63c115a6d90ca6f6"
    sha256 cellar: :any,                 big_sur:        "d4ca0398bf0728f5e5824ec4ef94f733d2e259058fe31843e8fa6f9fb6089dfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6a96bf194afbb49829454c7b3c90ccd32824cadc19b235a174d3c8a97b9518c"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    cd "wangle" do
      system "cmake", ".", "-DBUILD_TESTS=OFF", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "make", "install"
      system "make", "clean"
      system "cmake", ".", "-DBUILD_TESTS=OFF", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
      system "make"
      lib.install "lib/libwangle.a"

      pkgshare.install Dir["example/echo/*.cpp"]
    end
  end

  test do
    cxx_flags = %W[
      -std=c++17
      -I#{include}
      -I#{Formula["openssl@1.1"].opt_include}
      -L#{Formula["gflags"].opt_lib}
      -L#{Formula["glog"].opt_lib}
      -L#{Formula["folly"].opt_lib}
      -L#{Formula["fizz"].opt_lib}
      -L#{lib}
      -lgflags
      -lglog
      -lfolly
      -lfizz
      -lwangle
    ]
    if OS.linux?
      cxx_flags << "-L#{Formula["boost"].opt_lib}"
      cxx_flags << "-lboost_context-mt"
      cxx_flags << "-ldl"
      cxx_flags << "-lpthread"
    end

    system ENV.cxx, pkgshare/"EchoClient.cpp", *cxx_flags, "-o", "EchoClient"
    system ENV.cxx, pkgshare/"EchoServer.cpp", *cxx_flags, "-o", "EchoServer"

    port = free_port
    fork { exec testpath/"EchoServer", "-port", port.to_s }
    sleep 10

    require "pty"
    output = ""
    PTY.spawn(testpath/"EchoClient", "-port", port.to_s) do |r, w, pid|
      w.write "Hello from Homebrew!\nAnother test line.\n"
      sleep 20
      Process.kill "TERM", pid
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
    assert_match("Hello from Homebrew!", output)
    assert_match("Another test line.", output)
  end
end
