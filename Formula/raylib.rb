class Raylib < Formula
  desc "Simple and easy-to-use library to learn videogames programming"
  homepage "https://www.raylib.com/"
  url "https://github.com/raysan5/raylib/archive/4.0.0.tar.gz"
  sha256 "11f6087dc7bedf9efb3f69c0c872f637e421d914e5ecea99bbe7781f173dc38c"
  license "Zlib"
  head "https://github.com/raysan5/raylib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a661eadd8041310193930de3d8c945a9e0907e695423d944f0a54d1d559d8923"
    sha256 cellar: :any,                 arm64_big_sur:  "ac23867f939f0132beb5e0da421d8d6d668d4f5ca70cffc07e13fdecf75380a9"
    sha256 cellar: :any,                 monterey:       "7df796fdcda7fe67f7a115bd571ffd0aa55f8850be85a21f8e105c5674f26024"
    sha256 cellar: :any,                 big_sur:        "688d9af987c7c67aa3afac744c35d81a8e8c57d1d6b5afed1edb95791cdb7205"
    sha256 cellar: :any,                 catalina:       "a2c90a09cdbd887cfee09ac7caac37953401b32ee60643e4f25521bd8d6318b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7e03b969c31d5af57fff44d13ee2741198083cca3360ac126db73f555b4cd48"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxi"
    depends_on "libxinerama"
    depends_on "libxrandr"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON",
                         "-DMACOS_FATLIB=OFF",
                         "-DBUILD_EXAMPLES=OFF",
                         "-DBUILD_GAMES=OFF",
                         *std_cmake_args
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", "-DBUILD_SHARED_LIBS=OFF",
                         "-DMACOS_FATLIB=OFF",
                         "-DBUILD_EXAMPLES=OFF",
                         "-DBUILD_GAMES=OFF",
                         *std_cmake_args
    system "make"
    lib.install "raylib/libraylib.a"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <raylib.h>
      int main(void)
      {
          int num = GetRandomValue(42, 1337);
          return 42 <= num && num <= 1337 ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    EOS
    flags = []
    on_macos do
      flags = %w[
        -framework Cocoa
        -framework IOKit
        -framework OpenGL
      ]
    end
    on_linux do
      flags = %w[
        -lm
        -ldl
        -lGL
        -lpthread
      ]
    end
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lraylib", *flags
    system "./test"
  end
end
