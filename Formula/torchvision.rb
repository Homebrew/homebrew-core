class Torchvision < Formula
  desc "Datasets, transforms, and models for computer vision"
  homepage "https://github.com/pytorch/vision"
  url "https://github.com/pytorch/vision/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "99e6d3d304184895ff4f6152e2d2ec1cbec89b3e057d9c940ae0125546b04e91"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3e1c87431e9cfeecbf3460a2301e00452963ebbf8982be41ba2a19e9543882d3"
    sha256 cellar: :any,                 arm64_big_sur:  "b832c2dd9e48f9ccdbf4af596b1e4ca74fdb0bf04f5480488b0f8b8f0fe2b353"
    sha256 cellar: :any,                 monterey:       "01cada7a36876876e84ebc1fb1b29a3c3ecf9eb22e6f5896dd3b655edc5eb3f4"
    sha256 cellar: :any,                 big_sur:        "486dd6d545f2be3814008a28aba4d9a689574c822753a41b7fed7e1414220242"
    sha256 cellar: :any,                 catalina:       "ec0d214ed5005eca8efed8b57f0d5ebfe5f39a52fb0931714333b64f4b8762c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "137e7864ef5b43e6ec55614ccfac9d5a6e93775f2dc08c0397eca1159e74ee41"
  end

  depends_on "cmake" => :build
  depends_on "jpeg"
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
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test",
                    "-I#{libtorch.opt_include}",
                    "-I#{libtorch.opt_include}/torch/csrc/api/include",
                    "-L#{libtorch.opt_lib}", "-ltorch", "-ltorch_cpu", "-lc10",
                    "-L#{lib}", "-ltorchvision"
    system "./test"
  end
end
