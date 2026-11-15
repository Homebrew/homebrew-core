class Sdl2Compat < Formula
  desc "SDL2 compatibility layer that uses SDL3 behind the scenes"
  homepage "https://github.com/libsdl-org/sdl2-compat"
  url "https://github.com/libsdl-org/sdl2-compat/releases/download/release-2.32.74/sdl2-compat-2.32.74.tar.gz"
  sha256 "ec68abde77e2e459c8abc4f9587b8976b5d2a657b2bfda2fb3a079b0f8924588"
  license "Zlib"
  compatibility_version 1
  head "https://github.com/libsdl-org/sdl2-compat.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "139bf83cf71fda12c0ca21c6c5bd5b4d523b6129da62f4f4033b75550ff47a98"
    sha256 cellar: :any, arm64_tahoe:       "32ef73fe92e17d21856399165bc902f74f3c0e87d03021e3e945dfc4dd2d771c"
    sha256 cellar: :any, arm64_sequoia:     "0051ded084f7a73374bffe09df4cd6a0e70ccee6b3337a5843c152111bc01c28"
    sha256 cellar: :any, arm64_linux:       "81a904017f0b11fa215ce84b108cde785efc99380a7bd72bad8e68784535dd77"
    sha256 cellar: :any, x86_64_linux:      "ae3bfb210d01ab00c03a584cd5dff60271ad7ea152dbadac1e7ca35c850ce0d2"
  end

  depends_on "cmake" => :build
  depends_on "sdl3" => :no_linkage

  deny_network_access!

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
