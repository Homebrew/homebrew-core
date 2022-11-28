class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/releases/download/v2022.11.28.00/wangle-v2022.11.28.00.tar.gz"
  sha256 "b1a47bdcbac3a85f5f2ba048c3c1ed24b61a1eb9625319cc587cdd4d96782d76"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "60e8e0800fa1a6a388de405caf0c7e413590d5fac3e593e50bbf6798c267a265"
    sha256 cellar: :any,                 arm64_monterey: "6ebbf254624e71b5d38e812b0c832ef5f198a23f8e856417dd8ce9e99e806828"
    sha256 cellar: :any,                 arm64_big_sur:  "e0b0514d0de570347d13c1b6284f01a8197b60314a8429ebcb0410a3dd085ee6"
    sha256 cellar: :any,                 ventura:        "07741f00965dd087743700427bd9c921e100b372356e9d95b7e4ddcea543edf4"
    sha256 cellar: :any,                 monterey:       "b359e8aa51b1becf782d096768bf94fac6975cf648bea755d448e0a7ec2b975b"
    sha256 cellar: :any,                 big_sur:        "42cf3b141d03ae6627f649ec38eecd65b8a0868c007e8fb663cc6cd8f3c0c4ab"
    sha256 cellar: :any,                 catalina:       "8aaa387b1652451dea8047c48696156dc38fd8190e23e5330009610a392e64b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "feb4cce527550c951eef55856b54571eaa08afc1d459a0e13d32117d2ddb5578"
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
