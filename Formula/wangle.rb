class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2023.01.30.00/wangle-v2023.01.30.00.tar.gz"
  sha256 "03e981ffca04aa11605eb129a9a1efdf4fd0828ac83b814852ca8caf3b8694fa"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5c193d278b888975ab53040d13fe58362b369de4ae5990bb55cb1446b7746f4c"
    sha256 cellar: :any,                 arm64_monterey: "b28721083667ebe88640cf4fa965b0f03da670c108796fed2e15c8b0e93c8bf3"
    sha256 cellar: :any,                 arm64_big_sur:  "02f63bc681b017be28f0746b721336b778168b1201a4b53570a4e8d18467c12a"
    sha256 cellar: :any,                 ventura:        "3fbfd646105a81a973e994783ec6db3d52cc1d59cc6d39193c6a2a618a00e724"
    sha256 cellar: :any,                 monterey:       "30a759e1e57e0d33298cd161633cc3484c1a4f60d76b157259032d069f4cb9b2"
    sha256 cellar: :any,                 big_sur:        "76ad6d02325bc55893e1b4207eba7325650d5a86ea31d630883e9b074cfce71d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fb5057213b6e82c21a8b774656a76a37506b7840781124b1ee5a0721dc688ae"
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
