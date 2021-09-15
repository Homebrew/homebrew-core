class Sleef < Formula
  desc "SIMD library for evaluating elementary functions"
  homepage "https://sleef.org"
  url "https://github.com/shibatch/sleef/archive/3.5.1.tar.gz"
  sha256 "415ee9b1bcc5816989d3d4d92afd0cd3f9ee89cbd5a33eb008e69751e40438ab"
  license "BSL-1.0"
  head "https://github.com/shibatch/sleef.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 big_sur:      "1277b28f0a610af52bf3f646b4d893a08dd0d0d18004e04b439d47293b93b15d"
    sha256 cellar: :any,                 catalina:     "87ddfa37e9405dfc66c35295295e5f09e497fb1bc8c07c9e0f38560aeb46398f"
    sha256 cellar: :any,                 mojave:       "f9e95775f5e41924f42eae7c4ae1f567229a49989e1f8a380d55355e37680d9c"
    sha256 cellar: :any,                 high_sierra:  "353ca63589a038009ad9b39dadcf3ef4c46153f738fcfb07d58a25dfc37e945a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c03a8e095894d761b41adf5346c9839c8b3ed2f443c097c48f83d7921ec04c76"
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
