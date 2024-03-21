class Sleef < Formula
  desc "SIMD library for evaluating elementary functions"
  homepage "https://sleef.org"
  url "https://github.com/shibatch/sleef/archive/refs/tags/3.6.tar.gz"
  sha256 "de4f3d992cf2183a872cd397f517c1defcd3ee6cafa2ce5fa36963bd7e562446"
  license "BSL-1.0"
  head "https://github.com/shibatch/sleef.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5cc1fe8da1a1afa6d2b686ccc65abdf9a52bf1147e3817722fc2661424b735b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22527373f82cfd19b307bdc56ebc449dc81fac9e12080e7f282b28b3be913be5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f86a7bec0b3642735010325a1a15edc2acea912538b55f8583936e9b6dc1c7f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ca7da36f88ac624244d6b235e256eedc753ae63720b89ba248c848b96510915"
    sha256 cellar: :any_skip_relocation, ventura:        "39c9e3a0faf326f8002f4051b7bfdb8192a6b19209fb7711352754cb38317eb6"
    sha256 cellar: :any_skip_relocation, monterey:       "020d64210fd44ea2dc3570abecfced1b399b2049c161a15f5b1bdb6f9f023c54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8fda2d508070d75076ee173daf8a8c9437e3c37a71fd96e46b7931202082fde"
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
