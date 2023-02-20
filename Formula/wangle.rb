class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2023.02.20.00/wangle-v2023.02.20.00.tar.gz"
  sha256 "f94496e3c873dc06dd2a0e77000258e5bc7631c975fac616446bb0a8757e4d05"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bded2716baeb84a8b16c2c8c16b0cea38d514ee40e9858e3e836501aa081a86c"
    sha256 cellar: :any,                 arm64_monterey: "4ded8545724e70a4d79a8e4ecc73127ab6677efa94250853398be56abf31947d"
    sha256 cellar: :any,                 arm64_big_sur:  "0af4024e00ab407cdceac4589ffaf154cd68c0f0f93cfcc57b50ff83d54c9241"
    sha256 cellar: :any,                 ventura:        "0c762e91a575c19eced85633f525e0b103a203546342bb6978c3f13907b15f6a"
    sha256 cellar: :any,                 monterey:       "ac34881c137316994b707502e074f57b24fc19df64d7e55dcbcd10d3365984bc"
    sha256 cellar: :any,                 big_sur:        "e482ba645e1b1f7618d7a03b3e90c59f7f8f78fd74c382a36c36ff073204fb2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b6908781a2327eb48e49d5284120c5e19cceccef1b1d53b2ea76a489e439d83"
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
