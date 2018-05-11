class Raylib < Formula
  desc "Simple and easy-to-use library to learn videogames programming"
  homepage "http://www.raylib.com/"
  url "https://github.com/raysan5/raylib/archive/2.0.0-dev.tar.gz"
  version "2.0.0-dev"
  sha256 "e0aec21da642b4f373e9a6b628877dcc02a22a1267a7d6eace3ad5eb1ab33b5d"
  head "https://github.com/raysan5/raylib.git", :branch => "master"

  bottle do
    cellar :any
    sha256 "3b5f1087c97d056bb7cadfb1b9a4bfc5eda1069c53b3e63cbe613efe8df1dab2" => :high_sierra
    sha256 "ddc6fc916dbe713ad0df540b3e29060a439f977403d0226f2560b14fccfe617e" => :sierra
    sha256 "5556c1756d2a4de727350cff1d8d771cd28c142607a0adeb743bd2b16c94bd4c" => :el_capitan
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
