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
    sha256 cellar: :any,                 arm64_monterey: "a62246f4fc7b3a9ae5c60fa639acbcb5e816bceafd8012d9c8b9043a4ab2fab9"
    sha256 cellar: :any,                 arm64_big_sur:  "eeaf9f79fe88550ffcaceb197da8988d790be5ed9615a72782a29298d11486fe"
    sha256 cellar: :any,                 monterey:       "ae5f08fc5d3ef71123240741bc0d52ca9fdf0b1172c49774b602aa8e1c2f3748"
    sha256 cellar: :any,                 big_sur:        "0e2007b37beb9e4e93109d49c0ecd9a10b8693f4cc9321bc31c158cbd78d5d1b"
    sha256 cellar: :any,                 catalina:       "a4b28b4758ef43a587ab8b2256d90e5226494e167c45f2553368b8fdd7e3c01a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75d663161fc5639845c3c8193215ebc54af2842790ab6fd2fab193062f0c3460"
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
