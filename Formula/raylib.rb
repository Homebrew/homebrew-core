class Raylib < Formula
  desc "Simple and easy-to-use library to learn videogames programming"
  homepage "http://www.raylib.com/"
  url "https://github.com/raysan5/raylib/archive/2.0.0-rc1.tar.gz"
  sha256 "591dad75a3ff22597afa0011da4f92049942ea06fba32c723ea3d10d8dfb7da1"
  head "https://github.com/raysan5/raylib.git", :branch => "master"

  bottle do
    cellar :any
    sha256 "52050cce4e18ef31e617754b9acac0f95e5107d9555796c31120addaad880b0a" => :high_sierra
    sha256 "c3488979a2bc20f0ac91eae68e2318a987bb4c6bd4e5500c24e9dbe5e21fef1a" => :sierra
    sha256 "1155255c4f084e055c35373aafed4343e695982bf0c11c3e58f272cb3714cd59" => :el_capitan
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
