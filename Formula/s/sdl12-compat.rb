class Sdl12Compat < Formula
  desc "SDL 1.2 compatibility layer that uses SDL 2.0 behind the scenes"
  homepage "https://github.com/libsdl-org/sdl12-compat"
  url "https://github.com/libsdl-org/sdl12-compat/archive/refs/tags/release-1.2.78.tar.gz"
  sha256 "40ec5f0bab13a217ffae7aab0c450f1f798761e91fb185051b5211925c9da11a"
  license all_of: ["Zlib", "MIT-0"]
  compatibility_version 1
  head "https://github.com/libsdl-org/sdl12-compat.git", branch: "main"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "183ea3dc6721c9dae9d361bd72b94e9730ec5e9f531140bb0313a8aa5711fc4f"
    sha256 cellar: :any, arm64_tahoe:       "2f89409c4fea3a58ff48c41e09251f233f75663c889d6b118ae3a55b864dd36e"
    sha256 cellar: :any, arm64_sequoia:     "fc3cbc762465580e1e5e06dfbe735b12b7dd4616c14770851ada7efa995f8f62"
    sha256 cellar: :any, arm64_linux:       "8a304ebaaf778c8839b646b43861efa5a6ec59288f1327bc302192dbc38ceb82"
    sha256 cellar: :any, x86_64_linux:      "3350cb380469914492095fc3bb27ef519a160e8f679ab92289b072119679cdc4"
  end

  depends_on "cmake" => :build
  depends_on "sdl2-compat" => :no_linkage

  deny_network_access!

  def install
    args = ["-DSDL12TESTS=OFF"]
    args << "-DCMAKE_INSTALL_RPATH=#{rpath(target: formula_opt_lib("sdl2-compat"))}" if OS.mac?

    # We override install_prefix to make sure substituted CMAKE_INSTALL_FULL_* use
    # HOMEBREW_PREFIX path because most build scripts assume that all SDL modules
    # are installed to the same prefix. Consequently SDL stuff cannot be keg-only
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_prefix: HOMEBREW_PREFIX)
    system "cmake", "--build", "build"
    system "cmake", "--install", "build", "--prefix", prefix
    (lib/"pkgconfig").install_symlink "sdl12_compat.pc" => "sdl.pc"
  end

  test do
    assert_path_exists lib/shared_library("libSDL")
    versioned_libsdl = "libSDL-1.2"
    versioned_libsdl << ".0" if OS.mac?
    assert_path_exists lib/shared_library(versioned_libsdl)
    assert_path_exists lib/"libSDLmain.a"
    assert_equal version.to_s, shell_output("#{bin}/sdl-config --version").strip

    ENV["SDL_VIDEODRIVER"] = "dummy"

    (testpath/"test.c").write <<~C
      #include <SDL.h>

      // Avoid SDLmain's Cocoa startup in headless CI.
      #undef main

      int main(int argc, char* argv[]) {
        if (SDL_Init(SDL_INIT_VIDEO) < 0)
          return 1;
        SDL_Quit();
        return 0;
      }
    C
    flags = Utils.safe_popen_read(bin/"sdl-config", "--cflags", "--libs").split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
