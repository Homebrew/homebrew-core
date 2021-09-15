class Raylib < Formula
  desc "Simple and easy-to-use library to learn videogames programming"
  homepage "https://www.raylib.com/"
  url "https://github.com/raysan5/raylib/archive/3.7.0.tar.gz"
  sha256 "7bfdf2e22f067f16dec62b9d1530186ddba63ec49dbd0ae6a8461b0367c23951"
  license "Zlib"
  head "https://github.com/raysan5/raylib.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "95b223701f9d14ccde0080a0929e9f8db53b759d83209549295ade015de4ef7e"
    sha256 cellar: :any,                 big_sur:       "78a042f4d5d0c0f0172601d2768a74a7d9f3b3fa3224b6f301cf6c928f8242fe"
    sha256 cellar: :any,                 catalina:      "fe7414b8f44864b7382051eb74600f339a81c63aa5ef0eba6b64a7ff1d1d7292"
    sha256 cellar: :any,                 mojave:        "e8ac33fe22bfa1f12ec03d1bcd06728ea6cee3a6a91d806d46ffe9565a1cca27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86e833f587932092825be4023474979a2a6d6ec0f0858b6435f3408a143c0bdf"
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
