class Sdl3Net < Formula
  desc "Simple cross-platform wrapper over TCP/IP sockets"
  homepage "https://github.com/libsdl-org/SDL_net"
  url "https://github.com/libsdl-org/SDL_net/releases/download/release-3.2.0/SDL3_net-3.2.0.tar.gz"
  sha256 "098522fc26d4e302ef9348aee6e76e67fe504dfefd7f596236568f8330570c41"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL_net.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "86c2fac77dc6d19cccb56e691994de9e6c0955f3e14f8612c2d4c3ed8ec87e58"
    sha256 cellar: :any, arm64_sequoia: "77b305b714ad317207b7c54d915760dbd6850d135cf44f8ea7e0956cd9a1e36a"
    sha256 cellar: :any, arm64_sonoma:  "28a2033f3ee7d6c1af59e9f1e5d73a992e9bc24b1a0d8e12067a8b7f5dafc7d3"
    sha256 cellar: :any, sonoma:        "6cb7ecb2a22e695c12ae2e9351edbd850b52015132ff55e61e213a0ce3d01436"
    sha256 cellar: :any, arm64_linux:   "f50e382b3d2c484d1d966dfd3793c866ab1a1a126260dbfd6db22a2ff5612fbe"
    sha256 cellar: :any, x86_64_linux:  "bd77efbfe0fa2ca83cba994fddbe2d3b1c3071dd259e1d5161d431294933c4e3"
  end

  depends_on "cmake" => :build
  depends_on "sdl3"

  uses_from_macos "perl" => :build

  def install
    args = %w[-DSDLNET_INSTALL_MAN=ON -DSDLNET_SAMPLES=OFF]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <SDL3_net/SDL_net.h>
      #include <stdlib.h>

      int main() {
        return NET_Version() == SDL_NET_VERSION ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    C
    system ENV.cc, "test.c", "-I#{Formula["sdl3"].opt_include}", "-L#{lib}", "-lSDL3_net", "-o", "test"
    system "./test"
  end
end
