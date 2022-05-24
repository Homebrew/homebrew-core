class Sleef < Formula
  desc "SIMD library for evaluating elementary functions"
  homepage "https://sleef.org"
  url "https://github.com/shibatch/sleef/archive/3.5.1.tar.gz"
  sha256 "415ee9b1bcc5816989d3d4d92afd0cd3f9ee89cbd5a33eb008e69751e40438ab"
  license "BSL-1.0"
  head "https://github.com/shibatch/sleef.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 monterey:     "a2f45561f1e54a11176465997ed48539c21f2dded1940ea9f7dbdec016668b48"
    sha256 cellar: :any,                 big_sur:      "ab895eb9b9025676006d2f4b873f2b4a11e131ad2385c1c45b0a1421dd80e56f"
    sha256 cellar: :any,                 catalina:     "26f63745b1a4a16d5adfdcff61bf8214d4913419d8f1b3215b13b6cdfcaaecc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7b5bc626f2a7d23c258cafc340aef70a03adfbc814e9ae05637f606f850d3d96"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_INLINE_HEADERS=TRUE", "-DBUILD_TESTS=OFF", *std_cmake_args
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
