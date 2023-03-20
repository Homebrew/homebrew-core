class Raylib < Formula
  desc "Simple and easy-to-use library to learn videogames programming"
  homepage "https://www.raylib.com/"
  url "https://github.com/raysan5/raylib/archive/4.5.0.tar.gz"
  sha256 "0df98bfc553db31356cab46a2f9ed6d932065f186a0fff24bafa05f8a60e16d1"
  license "Zlib"
  head "https://github.com/raysan5/raylib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a3f03b9f6fc41dd1884d4c1694aa44a1ad0a035ddb1dc4dda690898d000cd407"
    sha256 cellar: :any,                 arm64_monterey: "10a1d493f6abdfd66b2d0639d848c5972e65df7a475b1e77210da59e60ff57b3"
    sha256 cellar: :any,                 arm64_big_sur:  "b50c3a4cea028ce463bce5f8cd857d61c9c0ac10fcab6f491cb62c98b08c3d08"
    sha256 cellar: :any,                 ventura:        "a5fa31296b157523b968e2ba6a913e11140a06b46600d14fff7dfca08dec16d3"
    sha256 cellar: :any,                 monterey:       "af0630c193767d75d93bead04d6b5ace6fa0db4f789f35a8980ec771b37face1"
    sha256 cellar: :any,                 big_sur:        "f62b1dde82d0f33e6fbda710e75b0a2f4a7559dc6588201419bce5f2f9ca4b92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d9f930f5a0e98eece43c16318eaaf42e94629d7f45e07c0b6765ee36fe70ece"
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
