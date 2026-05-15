class Sdl3Mixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://github.com/libsdl-org/SDL_mixer"
  url "https://github.com/libsdl-org/SDL_mixer/releases/download/release-3.2.2/SDL3_mixer-3.2.2.tar.gz"
  sha256 "cdb6d2a9f01bb3c1b98c957ee12109dd6ec1a1157682c9bc8523b0fe8ab2da1e"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL_mixer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "95a2042c9e134658d51f7237feb79c9522d892cbad4876b765d46cb927f231a7"
    sha256 cellar: :any,                 arm64_sequoia: "b318d375376b36a18aebfd9b43279004db97959b3d69df7904cab616ba1e7cb0"
    sha256 cellar: :any,                 arm64_sonoma:  "2faad709123d62b2eb3b850242ab570c227b4afe9ee12fcca9d111b530c26349"
    sha256 cellar: :any,                 sonoma:        "caabbe30dc99fddd23774254ce90a000d1be3f5bfa8f5a51d816d23f0ce81947"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a702ab215183d127cb2b537df40f140bc411204fc6fa3779c458e8c2916e8bdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4836437f259046905db88338f19a330b90c15ba50bdc12e55d4b99aee1c05156"
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
