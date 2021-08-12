class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2021.08.02.00/wangle-v2021.08.02.00.tar.gz"
  sha256 "d76c54c0a4cc800cf6059b7207352f2af6140e3f8e4b4431989ab018ba401170"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/wangle.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "f78a8dc2eba750f381964a3b7a8698107a2d94d0624040a2fd8d24d3fe064265"
    sha256 cellar: :any,                 big_sur:       "3902c2a98263c0662aad7099c56a4ded438c497bb04989a7dbf3afabcc225658"
    sha256 cellar: :any,                 catalina:      "66df7286118c89b6878ecf503ecbb46e876e42cd8a73b93c720b39df84454639"
    sha256 cellar: :any,                 mojave:        "a9b91fc1dd56c7e56d376877e9f69d242fd359d2ee0d691b8096e2221a421088"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0721ea9eecb12cf95c0a95ce206dd59f49ff6fce76fa85ff1d626892e7f2686d"
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

  on_linux do
    depends_on "gcc"
  end

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
      -std=c++14
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
    on_linux do
      cxx_flags << "-L#{Formula["boost"].opt_lib}"
      cxx_flags << "-lboost_context-mt"
      cxx_flags << "-ldl"
      cxx_flags << "-lpthread"
    end

    system ENV.cxx, pkgshare/"EchoClient.cpp", *cxx_flags, "-o", "EchoClient"
    system ENV.cxx, pkgshare/"EchoServer.cpp", *cxx_flags, "-o", "EchoServer"

    port = free_port
    ohai "Starting EchoServer on port #{port}"
    fork { exec testpath/"EchoServer", "-port", port.to_s }
    sleep 3

    require "pty"
    output = ""
    PTY.spawn(testpath/"EchoClient", "-port", port.to_s) do |r, w, pid|
      ohai "Sending data via EchoClient"
      w.write "Hello from Homebrew!\nAnother test line.\n"
      sleep 3
      Process.kill "TERM", pid
      begin
        ohai "Reading received data"
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
    assert_match("Hello from Homebrew!", output)
    assert_match("Another test line.", output)
  end
end
