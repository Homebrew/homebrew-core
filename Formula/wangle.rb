class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2023.03.06.00/wangle-v2023.03.06.00.tar.gz"
  sha256 "037db6cdcbdd1c5ba1613f7ee27e04a61dcce1b19163b64d0150fc5232761c58"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1fde7636d04bfc0155c0500f14135e46670000a0c7d538ff5ef9651e75cba53c"
    sha256 cellar: :any,                 arm64_monterey: "7f8868245ad7b2bef47daa918f21be79497c849035fa9709a2203743f159e96d"
    sha256 cellar: :any,                 arm64_big_sur:  "61baaa9ac62c3a37d4290b32498cc58613b72d261d782b5e982864d196203c0e"
    sha256 cellar: :any,                 ventura:        "782c9ec1b07c0cefcdfbc12bb9490c55386a877cc57cd71e0e466a5eb9d46562"
    sha256 cellar: :any,                 monterey:       "5c48ca5ad515217d2c38f1c7ea610ab7ec541b1c9d548e80490a935eee78d478"
    sha256 cellar: :any,                 big_sur:        "88f75fcc4a57b2caadbb770f97a5eea9393b2e41f97454351d40873783671e88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5af24788d4d98f231ed070b237f0747ccb81e6654d3ebfeaf06f69cef0c2223e"
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
