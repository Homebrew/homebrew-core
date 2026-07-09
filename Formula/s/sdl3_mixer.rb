class Sdl3Mixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://github.com/libsdl-org/SDL_mixer"
  url "https://github.com/libsdl-org/SDL_mixer/releases/download/release-3.2.4/SDL3_mixer-3.2.4.tar.gz"
  sha256 "182a07c745375e113dc740d43964ff21b0be29f29f59876c4dbc4db3d32f6901"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL_mixer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1ef6a957df04b6548af733489c732b70e084004b01d2d4694a3a64107c83a05e"
    sha256 cellar: :any, arm64_sequoia: "1e5166b7f478f5ecd11440db850c654cfd530d92297b95bdf62d3ea5f629bf8e"
    sha256 cellar: :any, arm64_sonoma:  "07ee48701fe1dbe1b97a184707f1f934687db8491f115bf50f09fdee445f7c5b"
    sha256 cellar: :any, sonoma:        "afa9f5f9b0d1fffc3f2646cb96b0dd775e8aec5bc2ad5f0fdd11d83a8178a29b"
    sha256 cellar: :any, arm64_linux:   "b03314551f619a0c94fa635d2e24581a009b16d6f239703c6015bb5d72a0a679"
    sha256 cellar: :any, x86_64_linux:  "8f757d6e85692cad2e9eea61fabea45d12f487cdf6a62688b47c7a1bf19b7e6d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "game-music-emu"
  depends_on "libvorbis"
  depends_on "libxmp"
  depends_on "mpg123"
  depends_on "opusfile"
  depends_on "sdl3"
  depends_on "wavpack"

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DSDLMIXER_DEPS_SHARED=ON
      -DSDLMIXER_VENDORED=OFF
      -DSDLMIXER_EXAMPLES=OFF
      -DSDLMIXER_TESTS=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <SDL3_mixer/SDL_mixer.h>
      #include <stdlib.h>

      int main()
      {
          int result = MIX_Init();
          MIX_Quit();
          return result != 0 ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lSDL3_mixer"
    system "./test"
  end
end
