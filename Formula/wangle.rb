class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2023.07.03.00/wangle-v2023.07.03.00.tar.gz"
  sha256 "cdc2783f6d17f5e757c19373ee4839de5c4c9e9ad820e17a2cf9deff3543f028"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3965a4c1b5120dde53dff57b4c7b675c95145d7dc50bcc81a7aea111cf186e5c"
    sha256 cellar: :any,                 arm64_monterey: "bfb16abe4dc15a8afec0fe85e08193a6b037dd72efc694795ab56b8f433f0a9e"
    sha256 cellar: :any,                 arm64_big_sur:  "bc608fa09638d32d12840435ff345ff2799b54ea23845477232a03a4fb8ba887"
    sha256 cellar: :any,                 ventura:        "5d3668b5f038d45ff583522df818cd2fd384e9c6d332120dbc17dfbd3b56c8c9"
    sha256 cellar: :any,                 monterey:       "4c16ed23d29e407a1f2271afd5ced18e72fd9d91f060620f0725e6576947d371"
    sha256 cellar: :any,                 big_sur:        "2768f185cd7c78b17095b2daf02bd35db245e87dfcd9b6fb37497e5e8d01e2a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "223faa6f020b8fb6792a5c3f7ea654934a55b5fb50007938752a7895a8b73efb"
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
