class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2023.01.02.00/wangle-v2023.01.02.00.tar.gz"
  sha256 "f1b5228bda2454cb2bda8fed29f70c316a03b05a1601e3874f7c91fbd35594ff"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3b1428a43b5658e9814976d559232228f861f118ea9d07e0dd7e999aa73cb462"
    sha256 cellar: :any,                 arm64_monterey: "f03699b8764172ce45fc6ba1b0aab99a743c5a8645cbea071a21046111731a25"
    sha256 cellar: :any,                 arm64_big_sur:  "a901f3194332ed6173bb5b84e86a364af67895034b0526c854f2cbf97630b233"
    sha256 cellar: :any,                 ventura:        "586326d8d58db391a9fb9547cb38bee415927cc5dc9e317cdcf74c1dd54df306"
    sha256 cellar: :any,                 monterey:       "84b642b4e90e5be9fd8f8ebc97fbd00f991dfa272384f43fd6662ac8f917673c"
    sha256 cellar: :any,                 big_sur:        "b24a6b59315f54371a1308649ee11bea2c022f2809fee23653c367f564bc3e48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c5ffd17cca7ccaa448b430b318f025b68cd26b9879f598ffe2aecb699a2f943"
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
