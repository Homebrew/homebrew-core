class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2023.06.26.00/wangle-v2023.06.26.00.tar.gz"
  sha256 "9a5d83874c36d4937fe711d210fbcf8a92ad45d21dda0e21e7613183f1082257"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "42c81899dd8cd89b67d6b82f5a426d2ddac091b8436e30398f961aa3b6c72e61"
    sha256 cellar: :any,                 arm64_monterey: "f8a0c7f3ba513503437f28cbc1c3db29d29bfa04ba6a32f5f99b75584b0375f2"
    sha256 cellar: :any,                 arm64_big_sur:  "e0232d839e4710ab1d2c0d1c8d2d51c3a559ef8abc015e862ac2a5b874fa99c1"
    sha256 cellar: :any,                 ventura:        "3af5185b919268d3228c0cfeae3d5c5c2e4cc23744161fe691b11ed959d641a2"
    sha256 cellar: :any,                 monterey:       "a27ef2621bcb0f9b3e9514971632765d99e3074ec9116fa84129518676df0827"
    sha256 cellar: :any,                 big_sur:        "3b47fb565ad69321b4266ba434acf6aeab577123e3a3ac9d2c3d6222ed0501fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6b91361a768323d3dabc948232545383842c7042c5593feeb659b57f5b0a079"
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
