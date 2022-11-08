class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2022.11.07.00/wangle-v2022.11.07.00.tar.gz"
  sha256 "79543a72059d5cb15945f5511a7a544f1347e420974d187ab0cf927b5bc69405"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7b6e3b71c11880f172959ba295d9391dfb9ac194f236d149cb32cac349a8daa1"
    sha256 cellar: :any,                 arm64_monterey: "bab6972c4acfc852a03e3d6dd60e130b0ae503292fa6812748cb40b661518472"
    sha256 cellar: :any,                 arm64_big_sur:  "e140562dbed8e3bfecbcb306bd7b19297d5b4ccb9f6251edd20f2beb37ce2a55"
    sha256 cellar: :any,                 monterey:       "7cbe45cc7ef6b6975f01462167291578d62ad222b4b0813d4fd430b5a1c27d43"
    sha256 cellar: :any,                 big_sur:        "0866a6cab29ffe051875f3dcd42bbba1002c26f1bf5885c1a4434390851a1449"
    sha256 cellar: :any,                 catalina:       "85b6103450bb2c750ec933af71cf0cd6fc074f96627b8f0dafe8a5d615924ce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fc9c0df67c2398a0e43230c1b4589818e605b99da92324eaf24fb2f743bd0cb"
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
