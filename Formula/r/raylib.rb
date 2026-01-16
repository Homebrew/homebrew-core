class Raylib < Formula
  desc "Simple and easy-to-use library to learn videogames programming"
  homepage "https://www.raylib.com/"
  url "https://github.com/raysan5/raylib/archive/refs/tags/5.5.tar.gz"
  sha256 "aea98ecf5bc5c5e0b789a76de0083a21a70457050ea4cc2aec7566935f5e258e"
  license "Zlib"
  head "https://github.com/raysan5/raylib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f5df67caba9995df0a73dd5759e3fc3236c5ae2cadd6f2bba89e9447ca922a2c"
    sha256 cellar: :any,                 arm64_sequoia: "b2040d26e8f4ff8b35da7e9a6f68186fab5497979d67475314900de05b90f031"
    sha256 cellar: :any,                 arm64_sonoma:  "16b1195332aee21f29004fce9e281fc1a97a8ac678265f15a4735ee9a9e1f554"
    sha256 cellar: :any,                 arm64_ventura: "b7dd5d1afd3c21145c7ca8e850f9acffb773a86ab05fa8b271d70fdc877874c0"
    sha256 cellar: :any,                 sonoma:        "27792cb3dacfecbebac27d0f131352dd83a8cfef788dc0c22eb981805a65bfda"
    sha256 cellar: :any,                 ventura:       "3e2398dfe727607adcb84c4f45144570235cdb97dba82eb0e01df188bf7776d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a59c2b0c8f2860a6373111e355eccca9170fb2aba77f9acd2aa5589c5de5b62f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "401315b8abc27b4351ec647fc8add4bdd8213012fe6d3200f1981afd357f7d7e"
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
    system "cmake", "-S", ".", "-B", "build",
                               "-DBUILD_SHARED_LIBS=ON",
                               "-DMACOS_FATLIB=OFF",
                               "-DBUILD_EXAMPLES=OFF",
                               "-DBUILD_GAMES=OFF",
                               *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "build-static",
                               "-DBUILD_SHARED_LIBS=OFF",
                               "-DMACOS_FATLIB=OFF",
                               "-DBUILD_EXAMPLES=OFF",
                               "-DBUILD_GAMES=OFF",
                               *std_cmake_args
    system "cmake", "--build", "build-static"
    lib.install "build-static/raylib/libraylib.a"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <raylib.h>
      int main(void)
      {
          int num = GetRandomValue(42, 1337);
          return 42 <= num && num <= 1337 ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    C
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
