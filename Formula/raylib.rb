class Raylib < Formula
  desc "Simple and easy-to-use library to learn videogames programming"
  homepage "https://www.raylib.com/"
  url "https://github.com/raysan5/raylib/archive/4.2.0.tar.gz"
  sha256 "5fd2e7d825f345924800c38291f44423bcbcc036bd72fa2e3abedfc54e5b68b5"
  license "Zlib"
  head "https://github.com/raysan5/raylib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "69e93e7dc849db008bca6c8c0a0cf107ecd890cd0f4a00b96ea28023a58d4e26"
    sha256 cellar: :any,                 arm64_big_sur:  "d7293b2408c9a266e0500d1f278a066ed40461d43e1b89517d04da5e96b67402"
    sha256 cellar: :any,                 monterey:       "bb1e50ec7d16791024f9597bb9c8ecdf7fec7efa1fe68dca386a9436754d4054"
    sha256 cellar: :any,                 big_sur:        "998493ec15c8aae5e4dd9566f51acd14839732b06f516f2b4f8eec2bd5a12448"
    sha256 cellar: :any,                 catalina:       "5a8f902f781f5a9b0b6650aab32257a1ddb682f200b00bfb6bb7c1cad6382b5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8f53583e14f95f4ddc15583aed1dcf69a7d49c803567974e9041a32aee4e126"
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
    flags = if OS.mac?
      %w[
        -framework Cocoa
        -framework IOKit
        -framework OpenGL
      ]
    else
      %w[
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
