class Torchvision < Formula
  desc "Datasets, transforms, and models for computer vision"
  homepage "https://github.com/pytorch/vision"
  url "https://github.com/pytorch/vision/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "99e6d3d304184895ff4f6152e2d2ec1cbec89b3e057d9c940ae0125546b04e91"
  license "BSD-3-Clause"
  revision 3

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f529abcd84607665ceb38504a3d2e428a9a2a8045cdba6f872eebca36c1cd5ca"
    sha256 cellar: :any,                 arm64_big_sur:  "2f5c89f380d583073b45e3779305eb7e6d661b5ad89b4ea4d52e000bf3f7ab7b"
    sha256 cellar: :any,                 monterey:       "c945a73465c33fe3b3c70d73b4bc21cb2eb6e7f4b50b92efcd1aefada2c99019"
    sha256 cellar: :any,                 big_sur:        "42f11c0cedc2fa68d794a7de44880608c1759c5d3ad3a44257ebd0a035b43cc3"
    sha256 cellar: :any,                 catalina:       "0b32716eed61ee7a9886eaae38a5d47b38735a1d1813dffd139c8ea9689032d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c62d6de5eda5fa07bcc68bf6e800fa504b0baad791b1255ec2f1b3d19b42b42d"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtorch"

  on_macos do
    depends_on "libomp"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <assert.h>
      #include <torch/script.h>
      #include <torch/torch.h>
      #include <torchvision/vision.h>

      int main() {
        auto& ops = torch::jit::getAllOperatorsFor(torch::jit::Symbol::fromQualString("torchvision::nms"));
        assert(ops.size() == 1);
      }
    EOS
    libtorch = Formula["libtorch"]
    openmp_flags = if OS.mac?
      libomp = Formula["libomp"]
      %W[
        -Xpreprocessor -fopenmp
        -I#{libomp.opt_include}
        -L#{libomp.opt_lib} -lomp
      ]
    else
      %w[-fopenmp]
    end
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test", *openmp_flags,
                    "-I#{libtorch.opt_include}",
                    "-I#{libtorch.opt_include}/torch/csrc/api/include",
                    "-L#{libtorch.opt_lib}", "-ltorch", "-ltorch_cpu", "-lc10",
                    "-L#{lib}", "-ltorchvision"

    system "./test"
  end
end
