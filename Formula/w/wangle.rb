class Wangle < Formula
  desc "Modular, composable client/server abstractions framework"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/archive/refs/tags/v2025.08.11.00.tar.gz"
  sha256 "42d51131ec0b6ec5bc96a43e81a4e85daaabba357f1e3b4d9f2c9f254b01b517"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/wangle.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8a812c75b53d243d8b4ef61711e9851d6c1ab119f43e17429ac22c0a1e2cfd67"
    sha256 cellar: :any,                 arm64_sonoma:  "84a23acf3ad45dd09c6a39215e789d9e24b102ab20400f900cb49976c2c55263"
    sha256 cellar: :any,                 arm64_ventura: "72847fa84f00e6f8b7cae870524986aec047550f6bc6266920e7dce9a09a2096"
    sha256 cellar: :any,                 sonoma:        "285d6c4e85d16bfdf483f24a3edb667bb4a3d32ce303dbf4765b9ad2b55ebdab"
    sha256 cellar: :any,                 ventura:       "251e893bc2b35a90cbca9e1a563261fe64e94bf9b0fd667dcd9d8f23fcb87380"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b287fb2126b844aa7bf9cb1ed1bbdfca765df79ab064147070544412a71fa049"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd949383a061d84a65d2337b69b44a2fd5bff6ca7554ff4916ff6a13a2901324"
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
    # libsodium has no CMake file but fizz runs `find_dependency(Sodium)` so fetch a copy from mvfst
    resource "FindSodium.cmake" do
      url "https://raw.githubusercontent.com/facebook/mvfst/v2024.09.02.00/cmake/FindSodium.cmake"
      sha256 "39710ab4525cf7538a66163232dd828af121672da820e1c4809ee704011f4224"
    end
    (testpath/"cmake").install resource("FindSodium.cmake")

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.5)
      project(Echo LANGUAGES CXX)
      set(CMAKE_CXX_STANDARD 17)

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
    fork { exec testpath/"build/EchoServer", "-port", port.to_s }
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
