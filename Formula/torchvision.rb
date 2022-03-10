class Torchvision < Formula
  desc "Datasets, transforms, and models for computer vision"
  homepage "https://github.com/pytorch/vision"
  url "https://github.com/pytorch/vision/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "99e6d3d304184895ff4f6152e2d2ec1cbec89b3e057d9c940ae0125546b04e91"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0394759957632e095ce784d0498bdba485c7fc9b9e21cb6ee992d813f00fcef6"
    sha256 cellar: :any,                 arm64_big_sur:  "c57b60bd4c4329944a3a22883da30100c826469c8858af6ca1f2217ee5ba7dd4"
    sha256 cellar: :any,                 monterey:       "c11f820731ef9af7fc6c9292346e378a755eb7f0d5ef72455cb971bcd42262fc"
    sha256 cellar: :any,                 big_sur:        "70fc77207f6be747ae5fa61739f068027ea1eec1fb3d65ae440066cb221fe452"
    sha256 cellar: :any,                 catalina:       "946dec06a712985319e1382a5ccf5ce3f9a74839543850992bc80825f3ffe0c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92d8e1959a6e85240dfe38e2788c1992222682d64547f4b7211424cc75850764"
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
