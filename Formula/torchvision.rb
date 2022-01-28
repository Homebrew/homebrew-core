class Torchvision < Formula
  desc "Datasets, transforms, and models for computer vision"
  homepage "https://github.com/pytorch/vision"
  url "https://github.com/pytorch/vision/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "b4c51d27589783e6e6941ecaa67b55f6f41633874ec37f80b64a0c92c3196e0c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "56d44e29f256c6910b9e934245a16596470928d313740cd7f85f20a3cfcb9a8a"
    sha256 cellar: :any,                 arm64_big_sur:  "a14bc100a71305de6ed2c8203e86f84fc5c46c42ba7b5e3fe43b3233886747a8"
    sha256 cellar: :any,                 monterey:       "7f2107b6c338e4c7a2591b5f9d4b4ad5015820bcc950543b9015633b99be54a8"
    sha256 cellar: :any,                 big_sur:        "eac9cb6c3f454d09fde67ea0e99699d4ac4dfb9dd76403b1f2494b09dc9e91ce"
    sha256 cellar: :any,                 catalina:       "c2891965afae03ac7e11464b727e09af3a9251bd49a814dd664ff0cf5926e2ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cc62bcfd4c2a7726201863b1771031b9c37ba5bdd2128c90c4c37fe8475d7cd"
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
