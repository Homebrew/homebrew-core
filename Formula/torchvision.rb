class Torchvision < Formula
  desc "Datasets, transforms, and models for computer vision"
  homepage "https://github.com/pytorch/vision"
  url "https://github.com/pytorch/vision/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "55689c57c29f82438a133d0af3315991037be59c8e02471bdcaa31731154a714"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bfab82b88e99434924a3b803398b86d6591564234d7b6cf07b4d4207c9b927de"
    sha256 cellar: :any,                 arm64_big_sur:  "28a7286d58001083c6a427464f3ed8b10405be59f620375645a348cc159d6159"
    sha256 cellar: :any,                 monterey:       "6584c8d8c368e9e6f71e1d02101ddb1ed9f21b8630096990d52955a61822ec82"
    sha256 cellar: :any,                 big_sur:        "ca777d8b7c150d77241c4dc45a6971450e9303bece7bca82be8babaeaa0a5694"
    sha256 cellar: :any,                 catalina:       "1abccf51e417a5fbdcdd4899b0cc668a1aaa11463779926302974fbc8e0cb362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae3fb710b69790725243a607bebca1b9bea7341fae4eebd3e55ec9cd8cfa1304"
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
