class Torchvision < Formula
  desc "Datasets, transforms, and models for computer vision"
  homepage "https://github.com/pytorch/vision"
  url "https://github.com/pytorch/vision/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "99e6d3d304184895ff4f6152e2d2ec1cbec89b3e057d9c940ae0125546b04e91"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8e3da95bf3f38a7ae2c906c865aa1a957ba5d64cbfde891881b220cd58b128b0"
    sha256 cellar: :any,                 arm64_big_sur:  "7b36479ebbee56621f533698eedb9672320cbb6171b61ac42f971367eb2f6a31"
    sha256 cellar: :any,                 monterey:       "f3e2086e7663e12800f34ed5ec1c83dfcb527e1bd3a1c9eeae0008622d585232"
    sha256 cellar: :any,                 big_sur:        "1392db123e9acfbe1b2e1bc31893995dd8394996c773ebae6b8f6150ca284d63"
    sha256 cellar: :any,                 catalina:       "f2a7c2fbd0024e6fbcc4fa689b3c30c678bc2b1f65841d61bcc318ea30865099"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6f90b0a16f9376a8a78cb219320222e5a0b5eab97caec72412e5d3983b15d71"
  end

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtorch"
  depends_on "python@3.9"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
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
