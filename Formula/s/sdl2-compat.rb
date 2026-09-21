class Sdl2Compat < Formula
  desc "SDL2 compatibility layer that uses SDL3 behind the scenes"
  homepage "https://github.com/libsdl-org/sdl2-compat"
  url "https://github.com/libsdl-org/sdl2-compat/releases/download/release-2.32.72/sdl2-compat-2.32.72.tar.gz"
  sha256 "a14d2f78dad8e83ef1039b6534ace4d14f11f5b11d023af989affd70ac1bb35e"
  license "Zlib"
  head "https://github.com/libsdl-org/sdl2-compat.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4df9883f271533e36571c11a809fc55d766ee89d3cdef4103eaa61915166b9bd"
    sha256 cellar: :any, arm64_tahoe:       "fbceadf543763868897ae643c8b04377e0971dfc0e8f3d9397bd80565016ec9c"
    sha256 cellar: :any, arm64_sequoia:     "1c2b54a84b2a24100e29fe48fb5b0d8b1f401de2e4470d375bbc2246f92ab8d2"
    sha256 cellar: :any, arm64_sonoma:      "0be6cd6dc97e29bf12d30baf103f813f34b3fbd9c7a1027c29edb0df2d85f239"
    sha256 cellar: :any, arm64_linux:       "f27ec0f54b565d9e7455bba97d4b6a01b516f3d686d848fc6631637bbcdd1dc1"
    sha256 cellar: :any, x86_64_linux:      "93931c0132043cfcc7daae237a8c79a67b563e5eebe35e58eaf1fcc6f4a48acf"
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
