class Torchvision < Formula
  desc "Datasets, transforms, and models for computer vision"
  homepage "https://github.com/pytorch/vision"
  url "https://github.com/pytorch/vision/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "32a06ccf755e4d75006ce03701f207652747a63dbfdf65f0f20a1b6f93a2e834"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "944aa1410b5facf24e763d0820cda7b713cdad1cd75664754dfd5af1ecdd6850"
    sha256 cellar: :any,                 arm64_big_sur:  "e22a045506f3805a5e6cedf8edb833df331ea3d2a62923a2d59531f05c31aa36"
    sha256 cellar: :any,                 monterey:       "ec7a4080578e012b13aacee6a4501911451d8e6800c58657f875796144683e04"
    sha256 cellar: :any,                 big_sur:        "1af21c171813ccf37d82a21c00f932dea60cd925a74f6934bf407d30abcb3024"
    sha256 cellar: :any,                 catalina:       "21c19ae566a5850dd94bfb5147c82797ad6c6177a5be8c9becf87fe4b1f0cc71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e539b96c551baffb301517f8f111238e7fdc4d3a0695dfb38a66855434c8bc94"
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
