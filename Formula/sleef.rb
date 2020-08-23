class Sleef < Formula
  desc "SIMD library for evaluating elementary functions"
  homepage "https://sleef.org"
  url "https://downloads.sourceforge.net/project/sleef/sleef-3.4.1.tar.gz"
  sha256 "25babe83b9358817ac05bbec09b7557439e4e96b907b86717906e6d980ff2036"
  license "BSL-1.0"
  head "https://github.com/shibatch/sleef.git"

  bottle do
    cellar :any
    sha256 "d8ae909caeaf4b8341254b458931ac8b4264d9acbfc7232ffa4dcd2bfaa93248" => :catalina
    sha256 "0b16c2e2daa5b3521e195d183daa70ea8f7cc4a5dd4924610c82945846ba0c81" => :mojave
    sha256 "fd59d2dc9fc8c757054a16f2dfb19d8b0a2eebb48e34de8ce67f585bb8b7e586" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_TESTS=OFF", *std_cmake_args
      system "make", "install"
    end
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
