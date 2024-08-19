class Sleef < Formula
  desc "SIMD library for evaluating elementary functions"
  homepage "https://sleef.org"
  url "https://github.com/shibatch/sleef/archive/refs/tags/3.6.1.tar.gz"
  sha256 "441dcf98c0f22e5d5e553d007f3b93e89eb58e4c66e340da8af5e7f67d1dc24c"
  license "BSL-1.0"
  head "https://github.com/shibatch/sleef.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57b897afdfdb7f9d55a4e9923cc54c8ebac403941369e1c32dc21e8ecfd7b0b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3529a62931aa034cf06c291013d11ab3c1daf0990b2998843f67fa468c806ca3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2f235034b6168198c72fdb8ffff3de8faac3c30f7dad4f69e307dbbb87c1d8f"
    sha256 cellar: :any_skip_relocation, sonoma:         "30eb6efcc98f1749e2b86f92c640b2d64cd6c4d05c96c40e2607fe4ea1d44ee1"
    sha256 cellar: :any_skip_relocation, ventura:        "e682ffd594eef018494ad0b424bfba7b5aa61585071e77e463a916e5c28f807b"
    sha256 cellar: :any_skip_relocation, monterey:       "67210cb8265cce9f713b1fec464c01106187ff3909847d89795a506205414f8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd22be8fbabf7cbe764a07b5cdb59deb4b0ae02f92409802d9b4b3b790cb172d"
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
