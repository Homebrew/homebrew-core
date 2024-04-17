class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2024.04.15.00/wangle-v2024.04.15.00.tar.gz"
  sha256 "3fd201bdef1762d842dce7f11d4e77cee419ec57966eafda0e652c158d4f5156"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8c3cd8ac6a67032d204cc57e359a1f2d04bf40aab24dfe7b7ba3720bfd1bad3a"
    sha256 cellar: :any,                 arm64_ventura:  "61b298e49f1be3ed6ebf5d229be48992c536f353e42c29279bf11d36005b4cba"
    sha256 cellar: :any,                 arm64_monterey: "8e583421ea90192af58b60be47111ad99f5e0af9dc56b4f1d01a2b0c97fe13b1"
    sha256 cellar: :any,                 sonoma:         "59ee30bfbacd3f4f8a12a0abcc147928fa02d6c181f35797188cea497c692ea3"
    sha256 cellar: :any,                 ventura:        "476a2bb61f8e76cea04b3ee1be12ee84429f63bdc83813269b4cd61ab65499e2"
    sha256 cellar: :any,                 monterey:       "6908289085ada98f7667532d784841e8c897b03ca3b22d420b13f3df0e6d8558"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2124cc55da74f57f5fe4c5b9906767d8a6d1f6d9ff8f0cd78a32d3d675ddb40d"
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
    args = ["-DBUILD_TESTS=OFF"]

    system "cmake", "-S", "wangle", "-B", "build/shared", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", "wangle", "-B", "build/static", "-DBUILD_SHARED_LIBS=OFF", *args, *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/lib/libwangle.a"

    pkgshare.install Dir["wangle/example/echo/*.cpp"]
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
