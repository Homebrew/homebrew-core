class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2023.01.23.00/wangle-v2023.01.23.00.tar.gz"
  sha256 "19f84d81896283fd1a2f9657a8efac5b169265dd82a10075690315090cd5ea07"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9398dbe100efb13211ead629ba9bc137b9587d3fa7ba27fb6917832f08658b38"
    sha256 cellar: :any,                 arm64_monterey: "adac63ba251d09d5e839c30080f4b420a31c9b2d4056c5d4474137623d2051f3"
    sha256 cellar: :any,                 arm64_big_sur:  "d484ba03cc818ef18d0936a63c7d331c709cb209864a69352d25ef8fddf73cf1"
    sha256 cellar: :any,                 ventura:        "2b02ae0343b45d7546efa614bfdbd19e37bb1a9472e6088e190b25dd36c2540b"
    sha256 cellar: :any,                 monterey:       "b15ef1e40d29428a2d0da851aade3ee0c9de2b9bb366ba53b353bc69a5cbc942"
    sha256 cellar: :any,                 big_sur:        "d71eb2bea0c4fc6f5a0c350cf8483c9811cb493a262a70e6e7183dbaa0b0c483"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e84e880463011267f0fb67e6691063dbca4fd7b00c1a790ccada4adb76d98bad"
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
