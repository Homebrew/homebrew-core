class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2023.06.12.00/wangle-v2023.06.12.00.tar.gz"
  sha256 "ad9225e810967f023af93376cc8484f66c0a7a0a9687f47e07a1ea7bef2662a1"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5b476bc5208a738c8b2d4722aa9832a0b311adbdd49f2cf1fa0cc140dc89af0f"
    sha256 cellar: :any,                 arm64_monterey: "e0c28b45d6abdc035e8da8c1ec91664ca41c2f9eb341fdf0de95ee3066c08c2a"
    sha256 cellar: :any,                 arm64_big_sur:  "78216a6fdf4e124472bdbf5b349a62b295751e38cb8ff3e7dbb0169def97b47f"
    sha256 cellar: :any,                 ventura:        "3817583d9dfdc5dc9bc5ac525e5382003ffc2c548deab7c46469e179ea6ee4cc"
    sha256 cellar: :any,                 monterey:       "7d2b65948f0ef00d751301ed49699d8201227fccc8d2c1292e5be4db8154c751"
    sha256 cellar: :any,                 big_sur:        "a61e79eec923aac3cc64a3a02ee22f83ed947712d9c6311fe7da0d3fd6c1112d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bd1624f3486bf268542fae8745e3ad3aff68213f16795732c7bcaed7e8a1d0f"
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
