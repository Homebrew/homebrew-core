class Raylib < Formula
  desc "Simple and easy-to-use library to learn videogames programming"
  homepage "https://www.raylib.com/"
  url "https://github.com/raysan5/raylib/archive/3.7.0.tar.gz"
  sha256 "7bfdf2e22f067f16dec62b9d1530186ddba63ec49dbd0ae6a8461b0367c23951"
  license "Zlib"
  head "https://github.com/raysan5/raylib.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "2411fb0870c9cec11f2f27f4d6f217fd7cff9351b65569970dcc3e27bee00964"
    sha256 cellar: :any, big_sur:       "079378b95371d4212b9603a41d3d44a838ad7fd07943cc902064251c644d2ef5"
    sha256 cellar: :any, catalina:      "78ef0455f7b3602829bf81c13dfeb81ca7867cde572bae477e6c2b9355289035"
    sha256 cellar: :any, mojave:        "ef45020d299bcb5c03f12f05b1a51791e155dce76073a54572ae5da04142fa7e"
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
    system "cmake", ".", "-DSTATIC_RAYLIB=ON",
                         "-DSHARED_RAYLIB=ON",
                         "-DMACOS_FATLIB=OFF",
                         "-DBUILD_EXAMPLES=OFF",
                         "-DBUILD_GAMES=OFF",
                         *std_cmake_args
    system "make", "install"
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
    system ENV.cc, "test.c", "-L#{lib}", "-lraylib", "-o", "test", *flags
    system "./test"
  end
end
