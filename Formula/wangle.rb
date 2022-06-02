class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2022.06.27.00/wangle-v2022.06.27.00.tar.gz"
  sha256 "e2be19a61593455ae03b99dc36247fedbbf3d9f7521065e78f85d838568dd139"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8fcb44aa0b95cd3a6cb2ef479a6a193114e706932588bff87c1cd68c1229812a"
    sha256 cellar: :any,                 arm64_big_sur:  "24398fa2441da9828ac75b66fa0e61e146b702f6c4f1f179eccb09cc4e084301"
    sha256 cellar: :any,                 monterey:       "c56b4e103ec67f6d1d0973dac5d2dcacd798639f0a265fb1be74cf77bad0fd19"
    sha256 cellar: :any,                 big_sur:        "de1aec2310cf9c596c226736db7ce2b7dc2b7a6e0bf7f0319f7ece41d2e5043d"
    sha256 cellar: :any,                 catalina:       "884bcabbabd73895ebed67402d49c7de8d28be1918e20490443f276375ca25e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ac3f7f22883d16697644e5f599f0e64c771b72d9d52c98ae44d0351dc1b9bc3"
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
