class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/archive/refs/tags/v2026.10.05.00.tar.gz"
  sha256 "4ba21ca487d25c66c9b56ce786dd4e7ba0724ac8f52b511f5529142d43a9940f"
  license "Apache-2.0"
  revision 1
  compatibility_version 1
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9fdf0a7df524decf49fb29dde2840693787d64830d1fe66729acc6e29e9be8fc"
    sha256 cellar: :any, arm64_tahoe:       "2142859b22e02bd68e8c4d7dbdf87ca7dd626fd10988823b7d375eac90c00cd1"
    sha256 cellar: :any, arm64_sequoia:     "972dc1be0d5ce63ca6065800d0c6831d1ac397485bae05d570548593495ce17e"
    sha256 cellar: :any, arm64_linux:       "b05be5434c398132598ae862cb40276135a18c22df69153cfafc7307eda1a08f"
    sha256 cellar: :any, x86_64_linux:      "8a129e42d8a0b07fd75d97ccf3dc221b03ce3335a73b6414ff22e2a0949fa5ef"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "libevent" => :build
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@4"

  allow_network_access! :test

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
      cmake_minimum_required(VERSION 4.0)
      project(Echo LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 20)

      list(APPEND CMAKE_MODULE_PATH "#{formula_opt_libexec("fizz")}/cmake")
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
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_MODULE_PATH=#{testpath}/cmake",
                    "-DCMAKE_BUILD_RPATH=#{HOMEBREW_PREFIX}/lib",
                    "-DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@4")}", "-Wno-author"
    system "cmake", "--build", "build"

    port = free_port
    spawn testpath/"build/EchoServer", "-port", port.to_s
    sleep 30

    require "pty"
    require "io/console"
    output = ""
    PTY.spawn(testpath/"build/EchoClient", "-host", "127.0.0.1", "-port", port.to_s) do |r, w, pid|
      r.noecho do
        w.write "Hello from Homebrew!\nAnother test line.\n"
        sleep 60
        Process.kill "TERM", pid
        begin
          r.each_line { |line| output += line }
        rescue Errno::EIO
          # GNU/Linux raises EIO when read is done on closed pty
        end
      end
    end
    assert_match("Hello from Homebrew!", output)
    assert_match("Another test line.", output)
  end
end
