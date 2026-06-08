class Sdl2Compat < Formula
  desc "SDL2 compatibility layer that uses SDL3 behind the scenes"
  homepage "https://github.com/libsdl-org/sdl2-compat"
  url "https://github.com/libsdl-org/sdl2-compat/releases/download/release-2.32.68/sdl2-compat-2.32.68.tar.gz"
  sha256 "401a64f5d0948f0d1a217cfdba4e72ce63d22f7a9fc3751251e0e3a175ff7703"
  license "Zlib"
  head "https://github.com/libsdl-org/sdl2-compat.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "747fcdcfc92367c95be9cde4d24847c4b30874c58c47610e433559c9afa8d58a"
    sha256 cellar: :any, arm64_sequoia: "7e75cc128a53c76c59bdb4ef91e020aaae02f61a93c030b8c4658ebbf1e43e49"
    sha256 cellar: :any, arm64_sonoma:  "a11078ca31066d4af631ac0718f61c4e473d72b8b3fb32c734484253e424214a"
    sha256 cellar: :any, sonoma:        "ef4b98d783cc363e282876852cb9b81d0c9407f05a454b6141d9f35531c3423a"
    sha256 cellar: :any, arm64_linux:   "6064d08bfe80b9ae4439597f97ab58cea1015028f6b8ea83f5f8192d2f5b489a"
    sha256 cellar: :any, x86_64_linux:  "5f6b1b7ff9e6b6ae868fa17eeb04177e95721144712c7d66a7e91a8aa3a25405"
  end

  depends_on "cmake" => :build
  depends_on "sdl3" => :no_linkage

  def install
    args = ["-DCMAKE_INSTALL_RPATH=#{rpath(target: Formula["sdl3"].opt_lib)}"] if OS.mac?

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
