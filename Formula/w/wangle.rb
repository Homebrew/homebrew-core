class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2024.03.25.00/wangle-v2024.03.25.00.tar.gz"
  sha256 "d3485665d1aa2a48c421d9c3947cb071019abd1b583f3e994417db15a22a8e5a"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b5a60766a19427590722c8650c347cd1fa44a6c2995ab3c25da4322e70c08aa0"
    sha256 cellar: :any,                 arm64_ventura:  "f79f5a7958655d80fa9539a73a4372b3d71e2608bae8a8d294956a6199283a38"
    sha256 cellar: :any,                 arm64_monterey: "371d030be339aa2e2e440c498395a71bde033fa9d30d0284af0e76a0fdc07f20"
    sha256 cellar: :any,                 sonoma:         "532f5bda547b73cce17a7cee2c4527c6d3281b6d3dd1cd0ad3282ca0f9caa4a8"
    sha256 cellar: :any,                 ventura:        "c47fac98d0215992b08185dc64bbaf6db112db6a2dd7cf352b21f9e3cbf7cda5"
    sha256 cellar: :any,                 monterey:       "dcc3087e0baef43364a3c1056b79de81b17e3329cbcb358f8219958430e0c654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d13dc43237b3a9c9ef9884166ab35e774500b7fec92ca447a24105ea07c8b275"
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
    args = ["-DBUILD_TESTS=OFF"]

    system "cmake", "-S", "wangle", "-B", "build/shared", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", "wangle", "-B", "build/static", "-DBUILD_SHARED_LIBS=OFF", *args, *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/lib/libwangle.a"

    pkgshare.install Dir["wangle/example/echo/*.cpp"]
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
