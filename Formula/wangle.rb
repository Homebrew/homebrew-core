class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2023.01.16.00/wangle-v2023.01.16.00.tar.gz"
  sha256 "165f590cf4f83d393c9f7690c0ed288f743531f401d2d6d4ac5f353864e471d4"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ce57d9bef747806459c19f2e7d0863f9e09f8820c1eab08d39c81f0055899456"
    sha256 cellar: :any,                 arm64_monterey: "2d6ef8169b415cf9c7d52094904118be2087ddd3282c946940890b006385d558"
    sha256 cellar: :any,                 arm64_big_sur:  "e3fb32dff3a9e39581c25b60777c225707ea2d53f37e4989e4cbc2d1856a5a78"
    sha256 cellar: :any,                 ventura:        "3f067920d85d82f773888eff8b1d0c2b30b1e9bf44297bdc196eafe9259599cc"
    sha256 cellar: :any,                 monterey:       "5aae1ca3545160166e392a2660199f58a5fd37393d394bece444597a6a65ee1c"
    sha256 cellar: :any,                 big_sur:        "8a2d989203f8ee5c319534ba1ffccf7c93c40a2a83a4f71de1e2e075e6ebc0f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ae734c7c5a5d9bf1b9eacdc68b6d9e6e9f924d2cb0452b9841688b96c590739"
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
