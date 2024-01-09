class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2024.01.08.00/wangle-v2024.01.08.00.tar.gz"
  sha256 "6ab623c6deea78f53425ecbd36526a826feddac313a7c24895cdceb6c8dc6720"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "751907591659e28eb5ad912ff6e5b791f08265e5f7d4f03f57a2639851954835"
    sha256 cellar: :any,                 arm64_ventura:  "6eeb4c99223db262532b85b7e06bcb0e7b69a16ba59d7bb3310f3dbfd264d2d8"
    sha256 cellar: :any,                 arm64_monterey: "7d16bcc2c2d664c4200d89c590ab5a5b751078377f5c6569faf1606a8e831ebf"
    sha256 cellar: :any,                 sonoma:         "6b53adf9c3464d73216c5a3b892c0d3110cc49b4619deab4ea7693b83873e029"
    sha256 cellar: :any,                 ventura:        "5f84990f96164546b6d35f9241c9a4a8a84014077b76046f2ce7e4f458b7bc3f"
    sha256 cellar: :any,                 monterey:       "96f10a4ea27e1ff95196fd548e1ec4af00671a35ffc9fb5317a029d583f619f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb01031e260e3167d5611ad879f92524569e62011fb5c59d2c930cbd84b8646b"
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
  depends_on "openssl@3"
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
      -I#{Formula["openssl@3"].opt_include}
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
