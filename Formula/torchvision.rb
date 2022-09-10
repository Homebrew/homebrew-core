class Torchvision < Formula
  desc "Datasets, transforms, and models for computer vision"
  homepage "https://github.com/pytorch/vision"
  url "https://github.com/pytorch/vision/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "c32fab734e62c7744dadeb82f7510ff58cc3bca1189d17b16aa99b08afc42249"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "034e6a9bf2d4381092a938887e7532ee2cfeaec740b86da6562fad8ec2bfd96c"
    sha256 cellar: :any,                 arm64_big_sur:  "25333f1d5f1e104ec05334fbdc0948928c2d7b869a5a909802c685e14763067f"
    sha256 cellar: :any,                 monterey:       "3476aad9daeea4638b93efe32c29d1696449bcce6f90c7e6e871fea9ef4e66a2"
    sha256 cellar: :any,                 big_sur:        "ab571c943fe13eaf4b653e90b67de094b8dca547fda47241dfd7d7b5b3bdfa76"
    sha256 cellar: :any,                 catalina:       "f5ff16e3262cfeedb5921d41782381075ca23fda57a92512e65d219adeeec8cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89b6fecf79be7b3d9a12e9705e93c006097430bb8f915329c5a9af8294cf5f4f"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "pytorch"

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
    pytorch = Formula["pytorch"]
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
                    "-I#{pytorch.opt_include}",
                    "-I#{pytorch.opt_include}/torch/csrc/api/include",
                    "-L#{pytorch.opt_lib}", "-ltorch", "-ltorch_cpu", "-lc10",
                    "-L#{lib}", "-ltorchvision"

    system "./test"
  end
end
