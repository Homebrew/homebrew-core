class Sdl3Sound < Formula
  desc "Abstract soundfile decoder"
  homepage "https://icculus.org/SDL_sound/"
  url "https://github.com/icculus/SDL_sound/releases/download/v3.2.0/SDL3_sound-3.2.0.tar.gz"
  sha256 "3348f3ecc653e21f2b7ed8e409f07c67b179fbbfba3b99c85698e6e5d7b5924c"
  license all_of: [
    "Zlib",
    { any_of: ["LGPL-2.1-or-later", "Artistic-1.0-Perl"] },
  ]
  head "https://github.com/icculus/SDL_sound.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "934528f51b4c39df59a8c22dc4ad42d418893b0e3cb6594112381f4f8885b930"
    sha256 cellar: :any, arm64_sequoia: "256cf0518afa8b156a212bff1960e97bed6c3ac9a14313d5aaa3532f74664161"
    sha256 cellar: :any, arm64_sonoma:  "2fb7aa95d48487074ca612b0549cc879a45c9aafefdf762e97e28a72b59e531d"
    sha256 cellar: :any, sonoma:        "98ceb2fefb3d4bd2c33ea0ce78939abd5386ec1c1334fea3dbbf94e0dd49cbf4"
    sha256 cellar: :any, arm64_linux:   "5e4e423530f7ab6bbf6d3b4e8aa8e49ecfab7c6513969ab8f912b25a0a2ed2c1"
    sha256 cellar: :any, x86_64_linux:  "c9c8513b93d96cfe8c3126178b5e34a74edf494a6ff79c4319fccd20519627ac"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test

  depends_on "sdl3"

  uses_from_macos "perl" => :build

  def install
    args = %w[
      -DSDLSOUND_BUILD_DOCS=OFF
      -DSDLSOUND_BUILD_STATIC=OFF
      -DSDLSOUND_BUILD_TEST=OFF
      -DSDLSOUND_DECODER_MIDI=ON
      -DSDLSOUND_INSTALL_MAN=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <SDL3_sound/SDL_sound.h>
      #include <stdlib.h>

      int main() {
        return Sound_Version() == SDL_SOUND_VERSION ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    C
    flags = shell_output("pkgconf --cflags --libs sdl3-sound").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
