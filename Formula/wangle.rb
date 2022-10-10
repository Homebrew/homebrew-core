class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2022.10.10.00/wangle-v2022.10.10.00.tar.gz"
  sha256 "45242738d1c008b0d76e883cdfe36cf0a8112753b81392e230465044190eb294"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "873be0afe9506c2366a0f11233d134def8840e9a88d4bbccf05136f7f0f52596"
    sha256 cellar: :any,                 arm64_big_sur:  "65a31dff2cd200dcd78e56355deb1e1aaff741cc26c47aad444cd620f4aa8daa"
    sha256 cellar: :any,                 monterey:       "eabcfc7dd5dbf84488847e008559e5259ce11a534726f2f7fbcf7f379e92ab8e"
    sha256 cellar: :any,                 big_sur:        "7d9eb478b1f5f31ff2c546140e7415e08081d92aa9b4117a262917f87e034113"
    sha256 cellar: :any,                 catalina:       "bf3adeeeb7b69deffcc352a71be2b4b530bbb74d620f265d306d204352176ad0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b2cc56916d22bf3a4960df40c31aed4c467877b5521a29db1f22f5876b35d7c"
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
