class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2021.05.31.00/wangle-v2021.05.31.00.tar.gz"
  sha256 "f3086e647c48af62db7ea995d33ba5499e34831eb902b3feeef172bd34fe0028"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "3cf51af1ca60b2d4025bced6f23bc951eca2604ce5eec169a0ab55cabd59e7d2"
    sha256 cellar: :any, big_sur:       "89e888475aa296413057f5864e853768718c051ca8145630489ba6f811b4ffc9"
    sha256 cellar: :any, catalina:      "baa2ae60c9ff268c6aa2edce73069095af971a5b45a8b25746fac2fba2eece14"
    sha256 cellar: :any, mojave:        "1316717f81ee54f2d4ac518eaed7c0d5b4bf9a62d5d763bd908700405c2a1920"
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
