class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2024.03.25.00/wangle-v2024.03.25.00.tar.gz"
  sha256 "d3485665d1aa2a48c421d9c3947cb071019abd1b583f3e994417db15a22a8e5a"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c389b6382e4be7750db66b01b8a21bf51285f8ecbd4ece6daab9e29e22f65a53"
    sha256 cellar: :any,                 arm64_ventura:  "ea9d05a389218e6fc1b742d9e514acbbfa3537283f64018ee6914e7b33ea9ba0"
    sha256 cellar: :any,                 arm64_monterey: "320c2644faeef967f5c6541d19d9631a16b8f58df3569c7406cea1452db74b46"
    sha256 cellar: :any,                 sonoma:         "efa4c9590704603955f51d45907f4532d1e0e9e2fd4e39415cf45a7ecd8c4a07"
    sha256 cellar: :any,                 ventura:        "fc0988d8a8b305f8791b37319c8b2c273921894189e0a46d6575f1cfeef89894"
    sha256 cellar: :any,                 monterey:       "13ecf125809fe42d203952cb67c1ef61e5fae2c62f79835db7f79f2a0d332247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1ed02d1e79fdbbaf2e7586494847929cb1f21b782b3c1fe052b7f97f9bff106"
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
