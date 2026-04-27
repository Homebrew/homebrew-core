class Sdl3Mixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://github.com/libsdl-org/SDL_mixer"
  url "https://github.com/libsdl-org/SDL_mixer/releases/download/release-3.2.0/SDL3_mixer-3.2.0.tar.gz"
  sha256 "1f86fae7226d58f2ad210ca4d9e06488db722230032803423d83bad6d35fc395"
  license "Zlib"
  head "https://github.com/libsdl-org/SDL_mixer.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "40386376f65c2f80aa65dec1f95af9f0fcd55ad646218df600b686a4001db6b8"
    sha256 cellar: :any,                 arm64_sequoia: "099f6100d09f996c4d54f798cf199962b97bc4c0f123b2e78cdbbc7afdf02bfc"
    sha256 cellar: :any,                 arm64_sonoma:  "6adfa053dda12cddf303f134a053f2756ee6840c05160bf62fc5f83d92213b52"
    sha256 cellar: :any,                 sonoma:        "71dcfbb95c0bc67acc53260e88f8833547a7f631eaf8e8c80970456f77e62b21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "926eb9a8c8410348e9281ebb85805a736ec8992a3c63b04bf1538ab82598b306"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdb57e94cada153ef7c2069793a292c42e162b2c5ce0586a9313b325a37809db"
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
