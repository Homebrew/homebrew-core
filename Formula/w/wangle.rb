class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2023.09.18.00/wangle-v2023.09.18.00.tar.gz"
  sha256 "0e493c03572bb27fe9ca03a9da5023e52fde99c95abdcaa919bb6190e7e69532"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b90ebca461184df168e35ec923dd2cca3d459969f9b358a7645290af482940a1"
    sha256 cellar: :any,                 arm64_ventura:  "cadc1feef988a8b251b5de882889bd6d8c6afec0974845fe0e00a128b1433025"
    sha256 cellar: :any,                 arm64_monterey: "c17b74f28e02fd85478b6f6d804adfc0da22672a0dc92f98633dc126b93def21"
    sha256 cellar: :any,                 arm64_big_sur:  "e24e7f9694e59fbcf71c6059e5de566e56c99ef4304ea9a360ad490f58dfc3b9"
    sha256 cellar: :any,                 sonoma:         "a78fefe8345eb915432bf64c4fd0b96ebbb6b8a0c884c03a0c936914966ab765"
    sha256 cellar: :any,                 ventura:        "f46ac70c3eb5426d5f4ee25f8ffe74a994a2d8ed9ebaf535f50469daee7a7be1"
    sha256 cellar: :any,                 monterey:       "043a025c4e7e41cfa70e84c0e247d3d594bc2dc26c4a189b5747ce8307e87863"
    sha256 cellar: :any,                 big_sur:        "447db243e3b313a8391d8eafd65ca3a779c742aa1b863b4ab1f3c19533e57346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d41b1646f8a7314fa8e5639a817bab644438651c8d4ea1880c3132f730cc417d"
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
