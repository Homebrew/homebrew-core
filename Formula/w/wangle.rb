class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2023.09.04.00/wangle-v2023.09.04.00.tar.gz"
  sha256 "9590d97f21d47a74fd79bf96828041ab7967ec7027b7049ab7a6a8c38c28bd0d"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0878c91315f4ce197525f83ebee8253dfab2b00d98b99bf9774a3678cab4f69a"
    sha256 cellar: :any,                 arm64_monterey: "0c3bca50c2365866718a61407d792256546fb8c359528da644a1848e3899ee59"
    sha256 cellar: :any,                 arm64_big_sur:  "2aa801de47b6b2ae142e67b3e0b42609e222f52a1096f81d2908c1512f1db3c9"
    sha256 cellar: :any,                 ventura:        "ac589dcff2af65116c0ad896f652cbccdbba6a76d7c04e02f8b0b7d3f4dfba56"
    sha256 cellar: :any,                 monterey:       "cb2fa0fc79b9b1d9629bcdf6c56eaab4b15bb07d997b259325fe7b838f6614a8"
    sha256 cellar: :any,                 big_sur:        "47d7f31ce920dab07d662d1506435291f275452723d20d65578bd3d2acbeca7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "482a1a41497dc51d2c3885e27f813226267133ceab3e6665c7f020ad0da4a956"
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
  depends_on "openssl@3"
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
      -I#{Formula["openssl@3"].opt_include}
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
