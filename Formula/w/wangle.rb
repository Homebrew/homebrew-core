class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/archive/refs/tags/v2026.01.12.00.tar.gz"
  sha256 "49b8e318a44e6bcdce37d79644ffd4efc7084621d08b6822cc357047819634ec"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8a172ae7dffffdca0d35b7c852325ffca9a3397d23bf7be1904c99a53591d216"
    sha256 cellar: :any,                 arm64_sequoia: "db95b376628ec0d02351b5b1fe47e350c92e791c4a19ba602a90ce58b615bb84"
    sha256 cellar: :any,                 arm64_sonoma:  "fcfe0362677fa2be4eb73ba01a063881e45acf1c68e0b963d40c7a17553cf3da"
    sha256 cellar: :any,                 sonoma:        "e69a0a8b24a6f829469a9b4fc568d67a48b26519a4c529dd42d73000b0b7d213"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e39f25857a354e99e6f487022929142a611706a79919168aa132fb798723a945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96841635b471a9006bcc9b3f53b330507bd8c9dbe1e67b04490d545dd4bf7ac2"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "zstd"
  uses_from_macos "bzip2"

  def install
    args = ["-DBUILD_TESTS=OFF"]
    # Prevent indirect linkage with boost, libsodium, snappy and xz
    linker_flags = %w[-dead_strip_dylibs]
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,#{linker_flags.join(",")}" if OS.mac?

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
