class Raylib < Formula
  desc "Simple and easy-to-use library to learn videogames programming"
  homepage "http://www.raylib.com/"
  url "https://github.com/raysan5/raylib/archive/1.9.1-dev.tar.gz"
  version "1.9.1-dev"
  sha256 "892357fb44d340eb7449c23c425d660d98b34b91434400e7610514ef02698600"
  head "https://github.com/raysan5/raylib.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "f9d6fc5e2f92c15bb6da71df4e0344d9383e803c61a5322f0f202393814f48bb" => :high_sierra
    sha256 "bd564c34749237dfbc28c490184fd0fc39aab313f19f53fe3d73160dbdaf63e0" => :sierra
    sha256 "d650d0518043a7a38375d8816d1c13d2dfac3c6e5a3286f9dae379e8451d7ba2" => :el_capitan
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
