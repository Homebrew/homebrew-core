class Sdl2Compat < Formula
  desc "SDL2 compatibility layer that uses SDL3 behind the scenes"
  homepage "https://github.com/libsdl-org/sdl2-compat"
  url "https://github.com/libsdl-org/sdl2-compat/releases/download/release-2.32.70/sdl2-compat-2.32.70.tar.gz"
  sha256 "998fa62557eb46ffe7e5c3e2c123bc332f7df9d9f593b3ceed88ed1158428a44"
  license "Zlib"
  head "https://github.com/libsdl-org/sdl2-compat.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "72e2c794f8408fba73fd0345a4eeb4cac49badc134e91c680c6aa7fd685d5492"
    sha256 cellar: :any, arm64_sequoia: "b5da3b02dfd9a68368f62a317b29f845dad4f29e067fc4aa81a351ca527a82c3"
    sha256 cellar: :any, arm64_sonoma:  "7e8e4de5079df93683ca0749d8948eb44dc7546769ce662a59955a6d0a5d65d3"
    sha256 cellar: :any, sonoma:        "334e7c2148dce314b293ac851c4c20e40f6e67582d52e4dee9cfd27f6400ddee"
    sha256 cellar: :any, arm64_linux:   "2b6d44478a56f2362482d9be32601e42acf10e59dc2fff1a1db6b5e641e0c177"
    sha256 cellar: :any, x86_64_linux:  "710527b5b729316426641d49adb065f9c4c8a07f741682329955e9d3ead7a18e"
  end

  depends_on "cmake" => :build
  depends_on "sdl3" => :no_linkage

  def install
    args = ["-DCMAKE_INSTALL_RPATH=#{rpath(target: formula_opt_lib("sdl3"))}"] if OS.mac?

    # We override install_prefix to make sure substituted CMAKE_INSTALL_FULL_* use
    # HOMEBREW_PREFIX path because most build scripts assume that all SDL modules
    # are installed to the same prefix. Consequently SDL stuff cannot be keg-only
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_prefix: HOMEBREW_PREFIX)
    system "cmake", "--build", "build"
    system "cmake", "--install", "build", "--prefix", prefix
    (lib/"pkgconfig").install_symlink "sdl2-compat.pc" => "sdl2.pc"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <SDL.h>

      int main(void) {
        if (SDL_Init(SDL_INIT_VIDEO) < 0) {
          SDL_Log("SDL_Init failed: %s", SDL_GetError());
          return 1;
        }
        SDL_Quit();
        return 0;
      }
    C

    flags = shell_output("#{bin}/sdl2-config --cflags --libs").chomp
    refute_match prefix.realpath.to_s, flags
    refute_match opt_prefix.to_s, flags

    system ENV.cc, "test.c", "-o", "test", *flags.split
    ENV["SDL_VIDEODRIVER"] = "dummy"
    system "./test"
  end
end
