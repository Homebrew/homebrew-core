class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2022.10.24.00/wangle-v2022.10.24.00.tar.gz"
  sha256 "20eadb041cd814cbb2dc3f412e1b51f2db8f637dfd20e8d4620f3b016f704aaa"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "69266dc4490d5ecfc2b2e49f0a75967280da3366a632b4c2827c24f5955c2899"
    sha256 cellar: :any,                 arm64_monterey: "8c83679bb667acd73abf0f4f690ea6392a40ee24a12d5ac16d99363b773398f8"
    sha256 cellar: :any,                 arm64_big_sur:  "5bc3fd89eca95b8a045354bddbeec5772a5515748395d6d34f8327fe4ebb5d79"
    sha256 cellar: :any,                 monterey:       "01446846f8e93da3ca4a094e874af9489a3469b3288a19c0a5c3db3f87f4bd18"
    sha256 cellar: :any,                 big_sur:        "88afcc0900bfa3b17fdd5ac41994c43ebbcfde1deaa3dc9664398a91430ea0f3"
    sha256 cellar: :any,                 catalina:       "fe314a6f8e4e7757327325b12e6c1bdb8e2b17b04a506b0e72a803a03b734dcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09c4b8fbc863b7bb7cdb7e48fdd20e9748496321f19caf9f6eabbc6fd1230466"
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
