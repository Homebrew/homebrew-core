class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/meta/wangle"
  url "https://github.com/meta/wangle/archive/refs/tags/v2026.11.23.00.tar.gz"
  sha256 "0eeb85060bd8174b5cda2ad8cae6b3db95cba99a20e333eeb93e8e5afe438feb"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/meta/wangle.git", branch: "main"

  bottle do
    manifest_sha256 "d0e23c17b20b70272646ed5714fd1e47e33df0d2579563b8b83ecd780f7b46f8"
    sha256 cellar: :any, arm64_golden_gate: "74ca8d3dd47623f7bb1c29578b30cfeb8eeb21157cf0aa6d2f6988d6e2a731d0"
    sha256 cellar: :any, arm64_tahoe:       "1ef9ca1f1fb18c5ecc1667e4bb332b0287aa584535eb896d29b622306fc0a2a5"
    sha256 cellar: :any, arm64_sequoia:     "378410553fd5a13311de76cbc916f0c28ffb4232b38428896ac3eabbbe22a1ec"
    sha256 cellar: :any, arm64_linux:       "3402ed753f404eace1aeb7ae5c820da4aada1af95f38fe23ecbedd0587af9f56"
    sha256 cellar: :any, x86_64_linux:      "44f04a892cc8943b0abe6b5465c1733efc33c287a8540e1989cca6f08a15cada"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "libevent" => :build
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
    openssl_prefix = dep("openssl").opt_prefix
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_MODULE_PATH=#{testpath}/cmake",
                    "-DCMAKE_BUILD_RPATH=#{HOMEBREW_PREFIX}/lib",
                    "-DOPENSSL_ROOT_DIR=#{openssl_prefix}", "-Wno-author"
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
