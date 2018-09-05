class Raylib < Formula
  desc "Simple and easy-to-use library to learn videogames programming"
  homepage "https://www.raylib.com/"
  url "https://github.com/raysan5/raylib/archive/2.0.0.tar.gz"
  sha256 "d3b476b55cedcbcff49ecf96d262748e0bf17fd7c2d2f375ee781d409c2535f4"
  head "https://github.com/raysan5/raylib.git", :branch => "master"

  bottle do
    cellar :any
    sha256 "c451ee1f669fe0b652cf86c47a584f26c5cb7bc7094de8e7cedc2992a126891f" => :mojave
    sha256 "f2720058881ff3ea1c53feaf9b2a954c13bd5d7697f5cb324898c1803d88c69c" => :high_sierra
    sha256 "ba91ed78b312bd752e8e38277d541a1a986e698c2f4db1c47b821c33a7fd35c3" => :sierra
    sha256 "d8bf72a0f03c6582159646b17b10033a7d5256f391320d0491766479bade250e" => :el_capitan
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
