class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2022.12.12.00/wangle-v2022.12.12.00.tar.gz"
  sha256 "fe50677007d3d49edf308f49830a5a4fcd9173fcaade896969affea83af6b85e"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b7fdc2740a08dd5aed1de86d516036acfcc7d899b0f2526f24a250b0ab561eb2"
    sha256 cellar: :any,                 arm64_monterey: "a47ca6e5eae628f54eb8c2d4a9619f4fb756e4fc7e9166e5431963b8dbb3e7e0"
    sha256 cellar: :any,                 arm64_big_sur:  "b452f8df802983ffee20e2827e2b420a035a328aee650e9512506608a0be5481"
    sha256 cellar: :any,                 ventura:        "327029165d87a30bc0b01670e9e4f7141ff0854f8d409d80c860d2c7a37b2b0a"
    sha256 cellar: :any,                 monterey:       "81c57c7d10d3a4c4b8d60b0b45632d17976acedf06639acc4e4d08a9837ff86a"
    sha256 cellar: :any,                 big_sur:        "584de3c76df377373fe2966f3bd8e5b3a30b92876954e5cd3dc630f7aba91251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb8b007ee6f8c308159409f28d0ad4ab33772ac79d72c19a4384a0c63049138a"
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
