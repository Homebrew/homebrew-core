class Sleef < Formula
  desc "SIMD library for evaluating elementary functions"
  homepage "https://sleef.org"
  url "https://github.com/shibatch/sleef/archive/refs/tags/3.9.0.tar.gz"
  sha256 "af60856abac08a3b5e72a8d156dd71fec1f7ac23de8ee67793f45f9edcdf0908"
  license "BSL-1.0"
  compatibility_version 1
  head "https://github.com/shibatch/sleef.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "231f4874823402017c6c4d530da4880de1b75280be9efd3a3ed58f20f85355b4"
    sha256 cellar: :any, arm64_sequoia: "43a0be3a50217071368ed54a8cf45a1c2ac07c4d512fb45a71e62a438666d077"
    sha256 cellar: :any, arm64_sonoma:  "60a602bfb08d39afd06df530302aa477097aef6227f7b695bb929b482b36cf27"
    sha256 cellar: :any, sonoma:        "4a7509699b9ca06f5ddcaa0590ee5676d994310485679d6f59537c1d0bf9df68"
    sha256 cellar: :any, arm64_linux:   "55b6db57984f7952974af096e66d6ede6af5db879411e62b03d9899aa8ad6a58"
    sha256 cellar: :any, x86_64_linux:  "08bcc0775f5e94b0fbb8044b9f406250d08111673a38e5f52ac07fb3dc0c78df"
  end

  depends_on "cmake" => :build

  def install
    # Allow building SVE support for PyTorch.
    # TODO: Check in SLEEF 4.0 if SVE is disabled by default:
    # Ref: https://github.com/shibatch/sleef/discussions/673#discussioncomment-12610711
    ENV.runtime_cpu_detection if OS.linux? && Hardware::CPU.arm?

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
