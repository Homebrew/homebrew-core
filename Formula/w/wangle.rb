class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2023.10.09.00/wangle-v2023.10.09.00.tar.gz"
  sha256 "453f30bfcfa662ecbf5d6ab383ede9b4f57220888c6a3582e666a846c33a6f5d"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "827b49868265150ec2c21c2ad0fa3972adf2bb13e01f46be9adb22de54b30353"
    sha256 cellar: :any,                 arm64_ventura:  "2b538ebe265cbab67907eb345a5ce344ffc9f1599505045c10dcf2419a92f6fd"
    sha256 cellar: :any,                 arm64_monterey: "6036996636967799dde1e4f54e269237fbe239280f0dc58adfdc8f7b0405fe87"
    sha256 cellar: :any,                 sonoma:         "801b1a02fcef309835efd65bdedbe89ecccc2cf2f38721de441a26372257ac92"
    sha256 cellar: :any,                 ventura:        "20b69f3c6a245e966e13cf6607d37e2eaddd392b14939c1c8201b89f577ea7b8"
    sha256 cellar: :any,                 monterey:       "e98adb9f9a9dbdbe68648a140af33177b815ce9624dbeaa35edf827834b2989b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "821d0e10cc162cb9d5992c8bbcee549ed84d5ab4ecca60b0699e38fdca9e763b"
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
