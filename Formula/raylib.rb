class Raylib < Formula
  desc "Simple and easy-to-use library to learn videogames programming"
  homepage "https://www.raylib.com/"
  url "https://github.com/raysan5/raylib/archive/3.7.0.tar.gz"
  sha256 "7bfdf2e22f067f16dec62b9d1530186ddba63ec49dbd0ae6a8461b0367c23951"
  license "Zlib"
  head "https://github.com/raysan5/raylib.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "45ee54b47e188a2a28d37f9a3b3f20db4c66d797243b5ae4d0d06848b69052a3"
    sha256 cellar: :any_skip_relocation, big_sur:       "c0769e8dcddbdf6a51a17ef2c2932d599501671b0c635759aaa8b3e92a453849"
    sha256 cellar: :any_skip_relocation, catalina:      "b69dfaea0d6b4e126041ad6fec2b22566b469d82bc1055ce04a18a1615597afb"
    sha256 cellar: :any_skip_relocation, mojave:        "727311e42dbd1ecc8d25b0defa49ca674dff953ed868b246eea00bcda9e3a6a1"
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
