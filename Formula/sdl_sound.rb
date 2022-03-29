class SdlSound < Formula
  desc "Library to decode several popular sound file formats"
  homepage "https://icculus.org/SDL_sound/"
  url "https://github.com/icculus/SDL_sound/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "3527f05b7a3f00d8523cf25671598c85568b4e8b615ce7570113b44cbb7d555c"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3d4f5a23c1903de8dd7af9d9c736213c0d9acc103b842b87bced96d4d1f271aa"
    sha256 cellar: :any,                 arm64_big_sur:  "2da102c4035e6cd0138668695cbee5eed9f730077a78e7221e73cb2a047d915c"
    sha256 cellar: :any,                 monterey:       "a80556c4832609ffdf4d082e2b29e3737fbf04b3bceb13bc82993d0a4c734537"
    sha256 cellar: :any,                 big_sur:        "8a2c07271bbc94a345cd8951ed897e9d12edda47d713c247a77e3186780247fc"
    sha256 cellar: :any,                 catalina:       "b8ac8b382c94d4a92032a8bc9c93d777fac1367851bd3df382089f747c347f05"
    sha256 cellar: :any,                 mojave:         "3661daa8d14b8b8ab613a5fb449ad6b3f758739eb3b69700b23c0ccdc49068b6"
    sha256 cellar: :any,                 high_sierra:    "c571e007bcbb022e6fd0042e506ce6cd47a26d814de06f348b13231fc95a1581"
    sha256 cellar: :any,                 sierra:         "0e692b6c08600d6d7014fc582b5a351e8a4eea42ce95d231ef39a0c07c41c71b"
    sha256 cellar: :any,                 el_capitan:     "fd93d8be366bfe3f16839f50d11ab1149cc725c6bf6248befe90feae25c0e052"
    sha256 cellar: :any,                 yosemite:       "8f06d7c6c18c8a5192aebf5672c20f9f3b27bbd3109459ef96110d935c00f87b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b903c9b2b33a7c0ebf036d178f86d06adbc23ef8be891d49ed97312bc928d88"
  end

  head do
    url "https://github.com/icculus/SDL_sound.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl"

  def install
    inreplace "CMakeLists.txt",
    'sdlsound_decoder_option(COREAUDIO "CoreAudio" "various audio formats")',
    'sdlsound_decoder_option(COREAUDIO "CoreAudio" "various audio formats" TRUE)'

    args = [
      "-DSDLSOUND_DECODER_COREAUDIO=ON",
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    flags = %W[
      -I#{include}/SDL2
      -I#{Formula["sdl2"].include}/SDL2
      -L#{lib}
      -L#{Formula["sdl2"].lib}
      -lSDL2_sound
      -lSDL2
    ]

    Dir["#{pkgshare}/examples/*.c"].each do |r|
      system ENV.cc, r, "-o", "#{File.basename(r, ".c")}.out", *flags
    end
  end
end
