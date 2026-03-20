class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/archive/refs/tags/v2026.03.09.00.tar.gz"
  sha256 "020679cb67bbec2c2a7da678e5020f140415af0719ac7e159f028902e4eb5d8b"
  license "Apache-2.0"
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ba9ca36c6ec95ac9b0be748ffdfdf0340f3de4bd14423b9e5028e9941e69233b"
    sha256 cellar: :any,                 arm64_sequoia: "a182f41a33e71c80fcf90d70187ad448357ac3a6f02304348d4b2e9e284767c7"
    sha256 cellar: :any,                 arm64_sonoma:  "481ecb3b313205bda7f4a81be0932b5ab1e19ab089a9d5c4290cf1514fe821ab"
    sha256 cellar: :any,                 sonoma:        "cc32b8a5de8f66be7868626b5fd5b525f4bc99c618c7fe1212b932318b25a0e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06987016381e47d37fcb164b0eb88ccde48b2bf1da01dadf59f8ff89bb4ee9b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcc040adcbf74d3d7531a0bb9ae188988c88ac043e9affb60d8839f72e972492"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "libevent" => :build
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  def install
    args = ["-DBUILD_TESTS=OFF"]
    # Prevent indirect linkage with boost, libsodium, snappy and xz
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", "wangle", "-B", "build/shared", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", "wangle", "-B", "build/static", "-DBUILD_SHARED_LIBS=OFF", *args, *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/lib/libwangle.a"

    pkgshare.install Dir["wangle/example/echo/*.cpp"]
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.5)
      project(Echo LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 17)

      list(APPEND CMAKE_MODULE_PATH "#{Formula["fizz"].opt_libexec}/cmake")
      find_package(gflags REQUIRED)
      find_package(folly CONFIG REQUIRED)
      find_package(fizz CONFIG REQUIRED)
      find_package(wangle CONFIG REQUIRED)

      add_executable(EchoClient #{pkgshare}/EchoClient.cpp)
      target_link_libraries(EchoClient wangle::wangle)
      add_executable(EchoServer #{pkgshare}/EchoServer.cpp)
      target_link_libraries(EchoServer wangle::wangle)
    CMAKE

    ENV.delete "CPATH"
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_MODULE_PATH=#{testpath}/cmake", "-Wno-dev"
    system "cmake", "--build", "build"

    port = free_port
    spawn testpath/"build/EchoServer", "-port", port.to_s
    sleep 30

    require "pty"
    output = ""
    PTY.spawn(testpath/"build/EchoClient", "-port", port.to_s) do |r, w, pid|
      w.write "Hello from Homebrew!\nAnother test line.\n"
      sleep 60
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
