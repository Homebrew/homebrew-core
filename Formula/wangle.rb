class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2022.07.04.00/wangle-v2022.07.04.00.tar.gz"
  sha256 "8c7b538f9e9d84162056d6dc757bea1d0d4c0978889469f10e9d05b1dc4e5a83"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1e48f4f5969e450e56603a83a61aa3a21fedd74ef0c183f7a5414b274f436709"
    sha256 cellar: :any,                 arm64_big_sur:  "bd26f3cb49a3efd192b5b722da0a55d3351daadf2a92794b007c7a1f4a7e83a6"
    sha256 cellar: :any,                 monterey:       "28db5e777695672e61f7be52c2ef16c4e5351dee6a61514e6bb79b243444214a"
    sha256 cellar: :any,                 big_sur:        "f4c3bb469f39c7d019cdb7e9d700d59583ca3dbf86389d7f1e25692a9085621c"
    sha256 cellar: :any,                 catalina:       "aa4485c73ce8fbc32029b4ba5f573dfcf9471a4ee7293505def3aef9d07c8b29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bf638cfbd3723734e31d8dc92d240fc192cbbcc0c5970dc0443ef9df3c347b2"
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

  on_linux do
    depends_on "gcc"
  end

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
      -std=c++14
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
    ohai "Starting EchoServer on port #{port}"
    fork { exec testpath/"EchoServer", "-port", port.to_s }
    sleep 10

    require "pty"
    output = ""
    PTY.spawn(testpath/"EchoClient", "-port", port.to_s) do |r, w, pid|
      ohai "Sending data via EchoClient"
      w.write "Hello from Homebrew!\nAnother test line.\n"
      sleep 20
      Process.kill "TERM", pid
      begin
        ohai "Reading received data"
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
    assert_match("Hello from Homebrew!", output)
    assert_match("Another test line.", output)
  end
end
