class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2023.03.13.00/wangle-v2023.03.13.00.tar.gz"
  sha256 "037db6cdcbdd1c5ba1613f7ee27e04a61dcce1b19163b64d0150fc5232761c58"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7993db974bc3e5d09bb3997a4e013598f3d2f19a8d15441724c5c63ab682aec4"
    sha256 cellar: :any,                 arm64_monterey: "8db6016557202767acd6f2c1683bb3ea1f9f03062d2477b30022ba848fb5aac1"
    sha256 cellar: :any,                 arm64_big_sur:  "20634125526ffa31db358d88bbd21a807385ab5cf0b5755f329df87f0de81de5"
    sha256 cellar: :any,                 ventura:        "ff01742db58fd23f31dd9f041e950ea2df30e78f155a0528bfadbfa20a4e22d8"
    sha256 cellar: :any,                 monterey:       "6171d57a1ff2873b55b13746cfbe23597964a2835c075aeb355a0ba0774baad4"
    sha256 cellar: :any,                 big_sur:        "d2fa0f42d0cadb770fd424ef1f94b4ef73d2ae356aa7591b02b51b11929fde39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86c3100b03e510f409c5609f7b7954a19ac3c87fd3d5f65ed0e5e33c886d491f"
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
