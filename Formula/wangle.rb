class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2023.05.08.00/wangle-v2023.05.08.00.tar.gz"
  sha256 "27bda8af87f50ab9bf206d7d594c9b445c7c4474843f340df71f6e06fc7be388"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d41c45d744ce1be1298ed592ca2de9684fd356650814ffa5f13919edac24d659"
    sha256 cellar: :any,                 arm64_monterey: "6628d147a88feab048dfa9ab16cb1933618a85e13198566c4b60edbd583d3326"
    sha256 cellar: :any,                 arm64_big_sur:  "628ce9ff108b3689c670ec8b76f6c631beec6ba610c1f44642a002ac54a92627"
    sha256 cellar: :any,                 ventura:        "d0a175b63ea2265d41edfa10fae853feb627c3390d818e78676182a771b0e1af"
    sha256 cellar: :any,                 monterey:       "44e8ef56a3b26a4496e306e4aa08e505802203ac30c999936bb9367e1ba86c3d"
    sha256 cellar: :any,                 big_sur:        "a2999c8e4528235f6d462910328341d94ad92d8c8fcd98d7aa47f1a28cb7c163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f17fc616176f9bbf21e51a5d97dd8371eeb81ab4773308b3c9388b45a746755"
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
