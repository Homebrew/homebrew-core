class Torchvision < Formula
  desc "Datasets, transforms, and models for computer vision"
  homepage "https://github.com/pytorch/vision"
  url "https://github.com/pytorch/vision/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "2fe9139150800820d02c867a0b64b7c7fbc964d48d76fae235d6ef9215eabcf4"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a8abc7dbfca08d51ad4ca48365d6a512ba3352d9e147e5aea9818175f0115003"
    sha256 cellar: :any,                 arm64_big_sur:  "bd5a3236f787baf4cdb36e1c17b7c99c498d8369c4f707680657380ea23c8f01"
    sha256 cellar: :any,                 monterey:       "17bc494ea07ffd5df509b27c170321853628a06d90b8b381606a5676a3fbf5a3"
    sha256 cellar: :any,                 big_sur:        "d6e168be48958da4f48e80078275fbd3bc6d76734d89ed143efdd19b47855aaa"
    sha256 cellar: :any,                 catalina:       "fc2bfe3cf064e88c096a2fb867be43cec9ffbaef7ecc9981e721c5e57cd2a1e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6159968886d9c1c86e4f1f2e63d1555179e282e9836bed0e7db92908f87d04a"
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
