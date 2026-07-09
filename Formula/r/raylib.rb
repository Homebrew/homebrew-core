class Raylib < Formula
  desc "Simple and easy-to-use library to learn videogames programming"
  homepage "https://www.raylib.com/"
  url "https://github.com/raysan5/raylib/archive/refs/tags/6.0.tar.gz"
  sha256 "2b3ee1e2120c7a0796b33062c7e9a694dd8a8caa56a96319ac8c8ecf54a90d0b"
  license "Zlib"
  head "https://github.com/raysan5/raylib.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "15b25ecba281a742ded68d937b94128ac48ba99a38ca5472458a7677921665c2"
    sha256 cellar: :any, arm64_sequoia: "0034c21f3ddbf09ca8e3f47e15715c386521079fd24e6ceb4602ed4b354dcbd4"
    sha256 cellar: :any, arm64_sonoma:  "113800ffaaf2d633b7e57470ae982e99a0955297e93efca7b0085b191df73231"
    sha256 cellar: :any, sonoma:        "506bd5433099e45f6c2e2ec4275bbc17cbbc7f7429ff4e1d508b7818a20a49bb"
    sha256 cellar: :any, arm64_linux:   "7043c22df6ea2bd11ee9cc38cdf4f29ab2e90fe9d140da3cda96efd3f7eaaff7"
    sha256 cellar: :any, x86_64_linux:  "117389644a50a59966af649bcc25f5b1cb393de791fb8ea6abf54cf61c71b057"
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
