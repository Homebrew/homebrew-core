class Sdl3Mixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://github.com/libsdl-org/SDL_mixer"
  url "https://github.com/libsdl-org/SDL_mixer/releases/download/release-3.2.4/SDL3_mixer-3.2.4.tar.gz"
  sha256 "182a07c745375e113dc740d43964ff21b0be29f29f59876c4dbc4db3d32f6901"
  license "Zlib"
  revision 1
  head "https://github.com/libsdl-org/SDL_mixer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d8bbaa3d8355b9e72f369795d4b7a6b3f695db320f7c94711be608b08ea5e38d"
    sha256 cellar: :any, arm64_sequoia: "56f0a34fbcc4589982050b06868a9687a40941e40ceb14d6cc80464f1c20d496"
    sha256 cellar: :any, arm64_sonoma:  "0b009e0ddca72e010d8eafdc7d34e3e8dc4a655c1b789771883b5242a7f0f65d"
    sha256 cellar: :any, arm64_linux:   "3d97780e90f45f53b9060a5d7368d19d87c129ba4c671be4a139348e243d2b4f"
    sha256 cellar: :any, x86_64_linux:  "1ae54a07d87e9e8ec4c1dccb5333c86b5b8d6cf17dd0f823a9d9c830c4661b67"
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
      -DSDLMIXER_STRICT=ON
      -DSDLMIXER_DEPS_SHARED=OFF
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
