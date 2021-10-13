class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2021.10.11.00/wangle-v2021.10.11.00.tar.gz"
  sha256 "86ea13a16bd931ae74c955483e2e4450c26ded53379e0f6bbdd6211ac4a9206d"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "738704ab332ba33935014da9ce8e08f88d6924461a4c26e29e5f4e0d31e6ed13"
    sha256 cellar: :any,                 big_sur:       "467c37310a1a99e818bc3076f6463f4e951bf553015e8a526df1892cccd4c441"
    sha256 cellar: :any,                 catalina:      "1a542fa9fdfcb4b05a806b467474ec20e387730e07a367eff57102594db5e404"
    sha256 cellar: :any,                 mojave:        "a135696c118735e55096abb3900d08151c19c4dd14f613740082d07f0fa349a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04fd77abdf17c431f887e9310e0aea7a11a7e3a2908bd5288fdd44dd203a8583"
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
    on_linux do
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
    sleep 3

    require "pty"
    output = ""
    PTY.spawn(testpath/"EchoClient", "-port", port.to_s) do |r, w, pid|
      ohai "Sending data via EchoClient"
      w.write "Hello from Homebrew!\nAnother test line.\n"
      sleep 3
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
