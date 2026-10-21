class Raylib < Formula
  desc "Simple and easy-to-use library to learn videogames programming"
  homepage "https://www.raylib.com/"
  url "https://github.com/raysan5/raylib/archive/refs/tags/6.2.tar.gz"
  sha256 "df7a13129b1bec9e73a6962efff170beba310ee6eab8f94cd000b7316b4db5ee"
  license "Zlib"
  compatibility_version 1
  head "https://github.com/raysan5/raylib.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "673a7b53ade625117feee008a1a88a77ca068c5c01cfd9981c13f727f6a57540"
    sha256 cellar: :any, arm64_tahoe:       "a0f742f031ea902a5762fe6aded4461ffcad8d4c5d235b30f46919e01830a267"
    sha256 cellar: :any, arm64_sequoia:     "87705d21de2e87e0128096bb059310f1cc4bd0673a543b5f55a9b0e4f5d43191"
    sha256 cellar: :any, arm64_linux:       "0e0d6c2733a90fea8435402d5944b09ed587ec65576a4f0dbb9384c7459bbd15"
    sha256 cellar: :any, x86_64_linux:      "817953eff8058abeeb098a5faed76159947d2368190107fee34f5d404f1b2cd3"
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

  deny_network_access!

  def install
    args = %w[
      -DMACOS_FATLIB=OFF
      -DBUILD_EXAMPLES=OFF
      -DBUILD_GAMES=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=OFF", *args, *std_cmake_args
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
