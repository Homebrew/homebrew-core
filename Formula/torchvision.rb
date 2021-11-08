class Torchvision < Formula
  desc "Datasets, transforms, and models for computer vision"
  homepage "https://github.com/pytorch/vision"
  url "https://github.com/pytorch/vision/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "32a06ccf755e4d75006ce03701f207652747a63dbfdf65f0f20a1b6f93a2e834"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0b1b15f76d7b101c54086361a70a3b66d913468000e5abf11adfb5ecf4de99a0"
    sha256 cellar: :any,                 arm64_big_sur:  "b4a37607724f528b6a26d390e0b064a06d86f4bb7f5bfb870fbc84382bdc3551"
    sha256 cellar: :any,                 monterey:       "f0bc6094b0db65cd410ca4781ab2c5765c3e606a58a9ccb78999252380314310"
    sha256 cellar: :any,                 big_sur:        "538900976b4d7efd2ebc3be711c5565b2e20b5e504f84eb338e8dff4eb0aad2c"
    sha256 cellar: :any,                 catalina:       "fa859b8881a88ea26dc058759752b318a3d163b38256e3000fa5c61a0674d8f6"
    sha256 cellar: :any,                 mojave:         "f7375ac80c721fccfd1275f5d262d636d7584640507dbc3d047016dde36628aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18daac428fa8490aa00fab8e243ffa1ae6e5d7c446f3f445f73a519a301e535d"
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
