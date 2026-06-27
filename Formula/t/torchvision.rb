class Torchvision < Formula
  include Language::Python::Virtualenv

  desc "Datasets, transforms, and models for computer vision"
  homepage "https://pytorch.org/vision/stable/index.html"
  url "https://github.com/pytorch/vision/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "705d5ab7d01af9ece3bfbb1486eed3c23a2f68414fcc9c9a88910fb3c018c3db"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6cdbcce923d100be24139f1cf2a2bd822aaddf0067c4ff190949e02f14680bc0"
    sha256 cellar: :any, arm64_sequoia: "a4b4d02b357636c81f56a1471359752e7b97cfe947817e420bbdb0c43d0e7f63"
    sha256 cellar: :any, arm64_sonoma:  "440e9ff1c720965c4088c6a1abbf207362a5a2755bf559d0e2d89ce17966709c"
    sha256 cellar: :any, sonoma:        "9b64a307d4247d60a3230f3b0af35d0f677257e95e869ddf0a8e36134b47e456"
    sha256 cellar: :any, arm64_linux:   "9af8f4f10fbd0c39efdf83c417e06ec950e1baaeec32901fba07406e10f9a402"
    sha256 cellar: :any, x86_64_linux:  "f0a737e66a54198a72ca17f13c2027394584639fe9f0d251c7bf2712d22e8031"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "pytorch"
  depends_on "webp"

  pypi_packages exclude_packages: %w[certifi numpy pillow torch]

  def install
    # Avoid overlinking to `abseil`, `libomp` and `protobuf`
    args = OS.mac? ? ["-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs"] : []

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    jpeg = Formula["jpeg-turbo"]
    inreplace "setup.py",
      'jpeg_found, jpeg_include_dir, jpeg_library_dir = find_library(header="jpeglib.h")',
      "jpeg_found, jpeg_include_dir, jpeg_library_dir = True, '#{jpeg.include}', '#{jpeg.lib}'"

    python3 = "python3.14"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources

    # We depend on pytorch, but that's a separate formula, so install a `.pth` file to link them.
    # This needs to happen _before_ we try to install torchvision.
    # NOTE: This is an exception to our usual policy as building `pytorch` is complicated
    site_packages = Language::Python.site_packages(venv.root/"bin/python3")
    pth_contents = "import site; site.addsitedir('#{formula_opt_libexec("pytorch")/site_packages}')\n"
    (venv.site_packages/"homebrew-pytorch.pth").write pth_contents

    venv.pip_install_and_link(buildpath, build_isolation: false)

    pkgshare.install "examples"
  end

  test do
    # test that C++ libraries are available
    # See also https://github.com/pytorch/vision/issues/2134#issuecomment-1793846900
    (testpath/"test.cpp").write <<~CPP
      #include <assert.h>
      #include <torch/script.h>
      #include <torch/torch.h>
      #include <torchvision/vision.h>
      #include <torchvision/ops/nms.h>

      int main() {
        auto& ops = torch::jit::getAllOperatorsFor(torch::jit::Symbol::fromQualString("torchvision::nms"));
        assert(ops.size() == 1);
      }
    CPP
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
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *openmp_flags,
                    "-I#{pytorch.opt_include}",
                    "-I#{pytorch.opt_include}/torch/csrc/api/include",
                    "-L#{pytorch.opt_lib}", "-ltorch", "-ltorch_cpu", "-lc10",
                    "-L#{lib}", *("-Wl,--no-as-needed" if OS.linux?), "-ltorchvision"

    system "./test"

    # test that the `torchvision` Python module is available
    cp test_fixtures("test.png"), "test.png"
    system libexec/"bin/python", "-c", <<~PYTHON
      import torch
      import torchvision
      t = torchvision.io.read_image("test.png")
      assert isinstance(t, torch.Tensor)
    PYTHON
  end
end
