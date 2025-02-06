class Sleef < Formula
  desc "SIMD library for evaluating elementary functions"
  homepage "https://sleef.org"
  url "https://github.com/shibatch/sleef/archive/refs/tags/3.8.tar.gz"
  sha256 "a12ccd50f57083c530e1c76f10d52865defbd19fc9e2c85b483493065709874a"
  license "BSL-1.0"
  head "https://github.com/shibatch/sleef.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "16405933a99706aa818edd558e0f77f5d20981c2f78d4351dcd60f641fbeb93c"
    sha256 cellar: :any,                 arm64_sonoma:  "4353a2d37abe1ab4ef030d4d8c2fd9b48956806c2cceb5ea202fb1d1cb8fc425"
    sha256 cellar: :any,                 arm64_ventura: "e11e41f584a86a846b5cd8e4488b4deb3c88cde3d063c04f1c250e55aebde862"
    sha256 cellar: :any,                 sonoma:        "b0bb1670f0687e90eccb70db7a8406109e3b2f63839dba0664047e5a4cf2497b"
    sha256 cellar: :any,                 ventura:       "0c5407110ecd8adc8a7276df202f2eef550fb82357a31e33ceeb1c9d59900d8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2723b060f3e1596f398cffd6e722304e063bfd3ebf35e9f65aa9fc3c49fee324"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DSLEEF_BUILD_INLINE_HEADERS=TRUE",
                    "-DSLEEF_BUILD_SHARED_LIBS=ON",
                    "-DSLEEF_BUILD_TESTS=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <math.h>
      #include <sleef.h>

      int main() {
          double a = M_PI / 6;
          printf("%.3f\\n", Sleef_sin_u10(a));
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lsleef"
    assert_equal "0.500\n", shell_output("./test")
  end
end
