class Torchvision < Formula
  desc "Datasets, transforms, and models for computer vision"
  homepage "https://github.com/pytorch/vision"
  url "https://github.com/pytorch/vision/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "99e6d3d304184895ff4f6152e2d2ec1cbec89b3e057d9c940ae0125546b04e91"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "95a81e2487cce8ec5e953ef4f40d5bd92010dfbd251b5c89c67aa9c648ea5de5"
    sha256 cellar: :any,                 arm64_big_sur:  "cf323a92015fb4dfd5f111b5a96db9a89710dd7e7d4e8b293a04003c240aa312"
    sha256 cellar: :any,                 monterey:       "56f11efbec49756d54202f752288b1778e6293e4f4fac1c23dc2f4a24abac5f1"
    sha256 cellar: :any,                 big_sur:        "319b7a4c992f164af73a44122576781117fe69261e9278d3c7114edb05bf030a"
    sha256 cellar: :any,                 catalina:       "ee830f6a8655988e92756444bbf03dc5731a7f64e3c63c6adc55ac2184697a5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf1e6573ca9453275fb3afe8a1ac0115334b4cba66b3c59c09b6a42e92ae8685"
  end

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libomp"
  depends_on "libpng"
  depends_on "libtorch"

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
    libomp = Formula["libomp"]
    system ENV.cxx, "-std=c++14", "-Xpreprocessor", "-fopenmp", "test.cpp", "-o", "test",
                    "-I#{libomp.opt_include}",
                    "-L#{libomp.opt_lib}", "-lomp",
                    "-I#{libtorch.opt_include}",
                    "-I#{libtorch.opt_include}/torch/csrc/api/include",
                    "-L#{libtorch.opt_lib}", "-ltorch", "-ltorch_cpu", "-lc10",
                    "-L#{lib}", "-ltorchvision"

    system "./test"
  end
end
