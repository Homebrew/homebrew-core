class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2022.12.26.00/wangle-v2022.12.26.00.tar.gz"
  sha256 "ffb96b031ffc6dd468228d362cd5947699e48d51f2a3127eeb7099a07430aa85"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8d561e5486f232d6a0d2562b95ac20e799e85127297f3ec4099fc3dccdf0ad29"
    sha256 cellar: :any,                 arm64_monterey: "b9a20d9b0ca41387502ca9826efe85979c925440af9627c119919240e869eca0"
    sha256 cellar: :any,                 arm64_big_sur:  "487e26d37260d9f31cff6cd229bef3f478abbdd77b6bef0aa671a7a096c75e6e"
    sha256 cellar: :any,                 ventura:        "44144a38b6eca70c38eb476eeba96071bed2a6cf3516b8c9466d8ff9b2174e00"
    sha256 cellar: :any,                 monterey:       "0cd59333a962446f4729795d652be1845e04cc26c822ead5f373b86c17782a4f"
    sha256 cellar: :any,                 big_sur:        "0277bc125f6025862a3479243a524f6ebae668a89d6b28fbf9a2a1b2719dc73a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69a763c9dcc32d8cb3a9fdfb558a10c48870471a39294c721cdbd5bd3b4b2b0c"
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
