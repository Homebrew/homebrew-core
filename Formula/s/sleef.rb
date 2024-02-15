class Sleef < Formula
  desc "SIMD library for evaluating elementary functions"
  homepage "https://sleef.org"
  url "https://github.com/shibatch/sleef/archive/refs/tags/3.6.tar.gz"
  sha256 "de4f3d992cf2183a872cd397f517c1defcd3ee6cafa2ce5fa36963bd7e562446"
  license "BSL-1.0"
  head "https://github.com/shibatch/sleef.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "6737ba48789667ef56d391443b2477c67d68bc33762fd7ba088e0044c58fe7bb"
    sha256 cellar: :any,                 arm64_ventura:  "29d31e2b6f752ac2b2224ea8334746484f08caac8b5e007a3ae0c7bfb78938dd"
    sha256 cellar: :any,                 arm64_monterey: "e24cd50466a172fe2fe1fd38145d6380798b3a4358b2618ebcf5d75b53824761"
    sha256 cellar: :any,                 arm64_big_sur:  "72c41de0c2f48173012a81362bd53cc3339de27f716baa7ea5d4b17604cd4a67"
    sha256 cellar: :any,                 sonoma:         "1e495d3a4d9694c3b9b56346850aebe0e08467d3b5ce55f08cb5c9fb3d08c48c"
    sha256 cellar: :any,                 ventura:        "a4785640f8657134c06a22f2f427d8a6ace04e6fa8fdd55f1b4261c77625457a"
    sha256 cellar: :any,                 monterey:       "b5b0877f9aec2c35b1c42a06b0a86dbf9cb53c98a11f3399d0cac79a57d7676e"
    sha256 cellar: :any,                 big_sur:        "483dc0549bf982bdcb71e8e3e07be8042d17b52484ddca20425feb820c1fb0fb"
    sha256 cellar: :any,                 catalina:       "0e2a1b3e27c3c886864c498a597f1a9e0c5faae346d4b3a7eceb7ef44f763e57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5ab3809f9503bbc49c03b1b26b39ffde4ebdf4f5148a375d267ff3cc816ebd6"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DSLEEF_BUILD_INLINE_HEADERS=TRUE",
                    "-DSLEEF_BUILD_TESTS=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <math.h>
      #include <sleef.h>

      int main() {
          double a = M_PI / 6;
          printf("%.3f\\n", Sleef_sin_u10(a));
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lsleef"
    assert_equal "0.500\n", shell_output("./test")
  end
end
