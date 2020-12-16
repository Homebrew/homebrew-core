class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2020.11.23.00/wangle-v2020.11.23.00.tar.gz"
  sha256 "3629b00f9e057d8fcfdc122fbe1570465ca3d5eb207d392815b71048a8154574"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git"

  bottle do
    cellar :any
    sha256 "2686ae2afb6865f53421ffd01a869ce6ca4ab2618329aef82149db6149f5178d" => :big_sur
    sha256 "74ba97566da37dd176d5fc66aca6a1a89764168f09738d2b3f27206044a6e2b8" => :catalina
    sha256 "30e555b84de7030a59436208dd95092471ec0e73e48ab4200323c725e25ec974" => :mojave
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
