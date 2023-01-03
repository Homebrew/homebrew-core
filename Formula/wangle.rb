class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2023.01.02.00/wangle-v2023.01.02.00.tar.gz"
  sha256 "f1b5228bda2454cb2bda8fed29f70c316a03b05a1601e3874f7c91fbd35594ff"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d17b3feea2010a05072438605533101e5491b07e417b47b2ee4bcf7f200c37da"
    sha256 cellar: :any,                 arm64_monterey: "850efd7a3b2f76c4959b81ba3e4062de9bb849d66b8c1f0b7b2bf6f51cfb5b92"
    sha256 cellar: :any,                 arm64_big_sur:  "0f234801d46e0b4525808151788dd6a19c16c016b5f405a6902bc40e4a51d08b"
    sha256 cellar: :any,                 ventura:        "61cad95ad607482d24e58d1fe0de36441d46a13bb23f8d5db84f7674d23b1b1e"
    sha256 cellar: :any,                 monterey:       "bb524032b5401547cd08e960e29fc408113ec0cb8208802a58c7a5c6ac83b40b"
    sha256 cellar: :any,                 big_sur:        "8f0fb9c230b3d58819595bc8af66f94805a7b6dd89698c5b522649cc0d3a66d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38431a0e38619570162d609a665463cfd44bbee8055d5d56d9c630c419b60715"
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
