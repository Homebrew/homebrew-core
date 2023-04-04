class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2023.04.03.00/wangle-v2023.04.03.00.tar.gz"
  sha256 "e400f26253101a56ac415a3cdcb14ba5d63b66b935b7f36a66fe5be8df27b3ac"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7b3cb25bf75b789d68822f712365f225c67f2974ac7eecc18f8ed32a44fec7aa"
    sha256 cellar: :any,                 arm64_monterey: "a71a5ec58f0ff8309ccabdac286ddd19aa5a4971501a4f217f46d11e0e1e2d79"
    sha256 cellar: :any,                 arm64_big_sur:  "bb86a09e095e2895b9d06126ee240fed7f7de803b3f556bc450ac84219c1be7a"
    sha256 cellar: :any,                 ventura:        "32df587e0892a424e5ba4446c6a238798aec545122cc8036c644d248e76b9fe3"
    sha256 cellar: :any,                 monterey:       "481eb3ec60107ff1d1cbb591e3ff180343b648ca2beb951dfc55c5be6f0fbee7"
    sha256 cellar: :any,                 big_sur:        "f4483bd28f4ae74cd04ce144871b68462e45e069a7718834099a81131eaef227"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "541e53263fd379e3496b2029aded00f12c85c03f2b66351003cadaf9b611cfd1"
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
