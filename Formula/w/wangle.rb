class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/archive/refs/tags/v2026.10.19.00.tar.gz"
  sha256 "3c9c358026a1015d4ab85da976c01e946fe1d02f38966abbdeb5f293e085271a"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "390b13dc33fa251367d097b5b7a1068baf2c5ea32312d33a23982422728ad2d8"
    sha256 cellar: :any, arm64_tahoe:       "ead91649c0862a65f86167ab4c344d6a8226a4f52edc8b6007f4e5ec0b602f08"
    sha256 cellar: :any, arm64_sequoia:     "74d838f8362a60aad1d9c3e1e9ef9d321f8d00d2bcc6c0c332b94f419dee2f2c"
    sha256 cellar: :any, arm64_linux:       "bc3b28f9d6e2405f11a0c3234d8757779c2348af8c5bd41cc77ac21b52f1de98"
    sha256 cellar: :any, x86_64_linux:      "bcf49eb99acb6a0ba00103aa3ecb9af49726e510cf7878e4cbfc76bae4f58746"
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
