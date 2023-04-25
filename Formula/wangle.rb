class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2023.04.17.00/wangle-v2023.04.17.00.tar.gz"
  sha256 "cbc14c93ef4e89a51e3509578f04271744f8a61e1ee34afafecfab7b3a0e4b95"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ae3252a96050a4f1f3643f16bb47ae1803f34ffe39af131552a8ebac5abb956c"
    sha256 cellar: :any,                 arm64_monterey: "0c3c4563ecc51c0256afedd02caf4846b0b3a096762c7e8b704551af18ff73d2"
    sha256 cellar: :any,                 arm64_big_sur:  "39e2044753a693d674cb86d728a9214570b482bea64d7046fecee5694987d5d3"
    sha256 cellar: :any,                 ventura:        "3fc587a6f3e1436ec8f33a4150e00f1289ce4b279197bd68e8a4a9eb4d8d57ad"
    sha256 cellar: :any,                 monterey:       "791fe45b32695f328c430242b785d21271373a61f2d0c8a24e84780f9bea4118"
    sha256 cellar: :any,                 big_sur:        "16f077fab7fdd4e127e2a093d5d77f607c4e275e79fe32810d584bfee2992bf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df7915f21fab53b6cf514fef91caeb44e9d5dbcea48f1be5ebc19516c278cd6f"
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
