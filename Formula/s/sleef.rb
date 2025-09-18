class Sleef < Formula
  desc "SIMD library for evaluating elementary functions"
  homepage "https://sleef.org"
  url "https://github.com/shibatch/sleef/archive/refs/tags/3.9.0.tar.gz"
  sha256 "af60856abac08a3b5e72a8d156dd71fec1f7ac23de8ee67793f45f9edcdf0908"
  license "BSL-1.0"
  head "https://github.com/shibatch/sleef.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6fe0e3a672461f15dd47162c7ba32505c6b81c41886524687a59c7690c16f0ea"
    sha256 cellar: :any,                 arm64_sequoia: "10bd5e568d4abc431b8a8b604c5c3745106ba980dc71e1d22b607587e336bbf9"
    sha256 cellar: :any,                 arm64_sonoma:  "ae22110074bfadf5d5d11ccebb7b211ddfed87724d79fe232c1ba551702747e8"
    sha256 cellar: :any,                 arm64_ventura: "1dde65a699a3ec906047a473eab08828adac8f3592f91d87be5d6acab66f626c"
    sha256 cellar: :any,                 sonoma:        "a26d81be375d9034c487372812dcd426c2573843173b610142214415cd635be7"
    sha256 cellar: :any,                 ventura:       "aa5605545499143c1c1724ecb336205418686bcbed39080bca464794c8a0d924"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffe74cf398e3979d201cba4686213e9719d71b2a0c24d9bdb1046d130b87e3be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c160ff9688e9d6f8c98f84d380c667e351f9ea9d0726d121f7b423e9a70ccf02"
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
