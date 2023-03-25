class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2023.03.20.00/wangle-v2023.03.20.00.tar.gz"
  sha256 "acf384a41be5259cbf87d0a1e36f838d875184bfe86ece4b0471b7a0524bc5aa"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4dbab0d3e6b3f4570f205b8c6e2bf3b68d61b49ad3048907525378ee6298a74e"
    sha256 cellar: :any,                 arm64_monterey: "bfe0485a07bb9415f934437541fae04182c2b5e57b9c46ec59a345c5d3988c88"
    sha256 cellar: :any,                 arm64_big_sur:  "af0a3c453ebc10164d539fc70aab131e400fbb179ea09e7a87a8188d2c5a9f2a"
    sha256 cellar: :any,                 ventura:        "d8047fde9faa2d8da0b419395a45fe669ae652715f25c539ff02c2fe4ca96d18"
    sha256 cellar: :any,                 monterey:       "1318e12346c587c815a3f9efdb40bedf611984304b2d2efc0d0520b821939680"
    sha256 cellar: :any,                 big_sur:        "13a4569fcc58ccd50a4dbad068c5d5104ae9aeebd6a5281c9d8c8b1ba26daa31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dd0bd44ba1768dc5f015d98e412d1fd846838baf558c3e5270f8457d58d52bb"
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
