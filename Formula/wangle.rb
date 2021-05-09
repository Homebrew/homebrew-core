class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2021.05.17.00/wangle-v2021.05.17.00.tar.gz"
  sha256 "20e5570e50c86df5edc3ca9e1917bf17909bdf93d072518f87f5e6c8155560ef"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/wangle.git"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "d342708016810640594adcabcc295e6250ceb20613a3dae293978c82d739e483"
    sha256 cellar: :any, big_sur:       "ef86382b1c582f081506854e3a6b1a09cf6028ad49a89cd55145d14219768de0"
    sha256 cellar: :any, catalina:      "f23d1a8cb61a346d2837e8678fad5660c53af5dcc0f8443e06ac60c4fb2be3a0"
    sha256 cellar: :any, mojave:        "1f2d62202c9a417200b9846c645526ac35e9bb72e0fb017fde0dd5ae6de79942"
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

    system ENV.cxx, *cxx_flags, "-o", "EchoClient", pkgshare/"EchoClient.cpp"
    system ENV.cxx, *cxx_flags, "-o", "EchoServer", pkgshare/"EchoServer.cpp"

    port = free_port

    fork { exec testpath/"EchoServer", "-port", port.to_s }
    sleep 2

    require "pty"
    r, w, pid = PTY.spawn(testpath/"EchoClient", "-port", port.to_s)
    w.write "Hello from Homebrew!\nAnother test line.\n"
    sleep 1
    Process.kill("TERM", pid)
    output = r.read
    assert_match("Hello from Homebrew!", output)
    assert_match("Another test line.", output)
  end
end
