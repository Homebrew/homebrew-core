class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2023.08.14.00/wangle-v2023.08.14.00.tar.gz"
  sha256 "295d14af50ea459392a9192686972c4df04255a6bfc22dd45b1f6f830e9eddf1"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "500cad5f091c55fa6664364df8b74db334b7da566c1eaa588e6e35b527023816"
    sha256 cellar: :any,                 arm64_monterey: "df53dab9f59f049ef2335dc4b71bfa42da41df883e1e5511fb32e0256cc00526"
    sha256 cellar: :any,                 arm64_big_sur:  "b77d0d4edb90c7fb33c222c57d5a4267ec6978718c4417aa8b0dcae27cf02eec"
    sha256 cellar: :any,                 ventura:        "236b3702723c1f7a8b3f8c0def545f104aef9222663cbb52ecff1233463f084a"
    sha256 cellar: :any,                 monterey:       "a948de3a301454317a89095b073e77e8fc2f5286c6a3bd79ba2fb1c905265eee"
    sha256 cellar: :any,                 big_sur:        "dfa5f263f84eebf0b1860121c219534dfb557f8a9db74837e47f8a129f6b5ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb6831401aefbc92221dd6744a75c1342d70ff1fad5d4909f9c70c9fc8bc81e6"
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
