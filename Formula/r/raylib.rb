class Raylib < Formula
  desc "Simple and easy-to-use library to learn videogames programming"
  homepage "https://www.raylib.com/"
  url "https://github.com/raysan5/raylib/archive/refs/tags/5.0.tar.gz"
  sha256 "98f049b9ea2a9c40a14e4e543eeea1a7ec3090ebdcd329c4ca2cf98bc9793482"
  license "Zlib"
  head "https://github.com/raysan5/raylib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "875ed8fbb499eef33984ddfe1bd4b611dbee0c340c34bc766348812a7c89ac92"
    sha256 cellar: :any,                 arm64_sonoma:   "df780cb94deb60db33809e7fed26dfb908f0e56b94ba9446b81feb81341429a4"
    sha256 cellar: :any,                 arm64_ventura:  "6dfeb82614799cbb5ad1acbf7d5bb6c9b49aca625589792453d490eff0f06acd"
    sha256 cellar: :any,                 arm64_monterey: "fb4f24b408d7e9ff3288f1cad7faba81f649ebf271389fa81a2034175330c3ff"
    sha256 cellar: :any,                 sonoma:         "f5541a5c113575806fd5d0ecf0fa6a6ecccc5485745a7b3cf812003c8eea9914"
    sha256 cellar: :any,                 ventura:        "a855f2f9a4904451c9c1f70e4083869ba1927ac1e9093752467f4796e289ebd4"
    sha256 cellar: :any,                 monterey:       "c515bdd72672af2565897cb55c2d8d4adce5be582f7c0bb914f006d4471feeea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72ebd3844b3be772438ef23365d7e27dc2604b93e127560398bcc5dd568c4bd5"
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
