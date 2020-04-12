class Raylib < Formula
  desc "Simple and easy-to-use library to learn videogames programming"
  homepage "https://www.raylib.com/"
  url "https://github.com/raysan5/raylib/archive/3.0.0.tar.gz"
  sha256 "164d1cc1710bb8e711a495e84cc585681b30098948d67d482e11dc37d2054eab"
  head "https://github.com/raysan5/raylib.git", :branch => "master"

  bottle do
    cellar :any
    sha256 "53a1022229679e1443739700eb6f40f64b2df756e152935f269ee1c021a9a6fe" => :catalina
    sha256 "059cfacd3913512a6bfa3009d12be48820a751d1b6580125e6e4d04518a5d2c0" => :mojave
    sha256 "1c762c4ee3aedf56a7d1b6dc20aca351af276aeec2fb90fc0b17b5f5ab87a639" => :high_sierra
  end

  depends_on "cmake" => :build

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
    system ENV.cc, "test.c", "-L#{lib}", "-lraylib", "-o", "test"
    system "./test"
  end
end
