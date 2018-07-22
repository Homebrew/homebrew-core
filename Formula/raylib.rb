class Raylib < Formula
  desc "Simple and easy-to-use library to learn videogames programming"
  homepage "http://www.raylib.com/"
  url "https://github.com/raysan5/raylib/archive/2.0.0.tar.gz"
  sha256 "d3b476b55cedcbcff49ecf96d262748e0bf17fd7c2d2f375ee781d409c2535f4"
  head "https://github.com/raysan5/raylib.git", :branch => "master"

  bottle do
    cellar :any
    sha256 "6f137400e8ac9a85bedb20f2a78b9add718d3102eb192dcb39a747a8aa072af8" => :high_sierra
    sha256 "d6de8b5511151b186f2980d7030eef9b70b7df1f9f2f630b86e57d4c367d418b" => :sierra
    sha256 "6810dc0ceefcc26045a323d2868e2451cf1c21f6bad7d718a102045507b9869e" => :el_capitan
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
