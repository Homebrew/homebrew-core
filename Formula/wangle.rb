class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2022.12.12.00/wangle-v2022.12.12.00.tar.gz"
  sha256 "fe50677007d3d49edf308f49830a5a4fcd9173fcaade896969affea83af6b85e"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2bc4e8c0eb826381b2fea25ceba7d1ca61c5fa65d07d6dceedc09c0d13e07156"
    sha256 cellar: :any,                 arm64_monterey: "2d238e97309f01422cf51d5fc5d7aa0cb64583c45e836c880ec1ba251b3ee191"
    sha256 cellar: :any,                 arm64_big_sur:  "f131a7709aefe1b1cadeb646460bedce913bb7399178cb0e4dcc66816fd863c2"
    sha256 cellar: :any,                 ventura:        "fba57fa910f1f853c833d20f6281e09bdcdf1ff344ec6ebc4c49db7b95c055a0"
    sha256 cellar: :any,                 monterey:       "7c5a16124001f240e0d6349517461a519afd052964fc04c908c5b3bd0f20231b"
    sha256 cellar: :any,                 big_sur:        "0cff31c74be3c781af885cd19bda05597d4553b8c0ffd1c240f349fef52427f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2beec94fccca40fa2214be69b33cd20f9f50d4ad9d3148fdf244be097492143e"
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
