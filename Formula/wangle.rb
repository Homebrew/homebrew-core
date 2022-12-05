class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2022.12.05.00/wangle-v2022.12.05.00.tar.gz"
  sha256 "22f748254fed6d00bc25673e28e6a1422e593ff90130d85814312bcca61c4690"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "068e7445d3de664e7fbfefcbe4851073340fb4926f04cab53f6906de2efed377"
    sha256 cellar: :any,                 arm64_monterey: "d8d9b9bc474689b1edf36b3fb2a51d29bd46329b4d14a7d39a1998c0124d0aee"
    sha256 cellar: :any,                 arm64_big_sur:  "4c90519066b25b61b042983d6022687a13624ead40a4bb60538a19a27878b0a8"
    sha256 cellar: :any,                 ventura:        "f06120a07894421a09485790629408ae50b1dedc66e8c63f855dea0ac5a14fda"
    sha256 cellar: :any,                 monterey:       "b92e85728b087290df8fc98c07109bf955b6ccfd25ff8596072c1e3e83792f84"
    sha256 cellar: :any,                 big_sur:        "9b6bdc059243a887f814ce2f1fcc70da89aede68c884b5480d094d0df5194799"
    sha256 cellar: :any,                 catalina:       "07a6d99f8b2d5abe9ca0f851c46e2369d485a583defe6b23b2de0b357937e52c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e0c4bb3eeb2327048e0975d29fb4b8e86733211f6dca5352440d7e0549ec8b1"
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
