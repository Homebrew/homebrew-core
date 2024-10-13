class Sleef < Formula
  desc "SIMD library for evaluating elementary functions"
  homepage "https://sleef.org"
  url "https://github.com/shibatch/sleef/archive/refs/tags/3.7.tar.gz"
  sha256 "1fb094c1ba4c9f6ba16013715d6fdbd5b893c68e1737b6115ba31e27807de591"
  license "BSL-1.0"
  head "https://github.com/shibatch/sleef.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f314f76bab7b0a9e5c4a9c2fdce196f22a50104b9fb2a356a29fd265b0dc877b"
    sha256 cellar: :any,                 arm64_sonoma:  "3c70ef4e6b934eab2b466aad8d12b00cd6c9521d7d8255c13e853b2db95e5b7b"
    sha256 cellar: :any,                 arm64_ventura: "5a4428dda352365ebcb2575c19d6f7d6d31071ac0f02ee56a33dbac2a687390d"
    sha256 cellar: :any,                 sonoma:        "4e7b7ee4466eb00f7508343e14a21bc82355cb2d6ecb7e6cf021e818316650a0"
    sha256 cellar: :any,                 ventura:       "d7db46a5adc5a23bfe1073bb38099f6f6570b0242f1a463ac215d19463d4facd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e12c2a6d62246583630ecccc471d28e8f77b4263f551b23cdd5ec14c8dcf2265"
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
