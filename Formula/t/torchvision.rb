class Torchvision < Formula
  include Language::Python::Virtualenv

  desc "Datasets, transforms, and models for computer vision"
  homepage "https://pytorch.org/vision/stable/index.html"
  url "https://github.com/pytorch/vision/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "04c588d80e63903e1e4444db8a1c32dc56e4080ed48782555e1d00752d6edb17"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5be36a465105945ca6e41c34dcc67a96f164efc7a7d06819d9ed08ad302fa425"
    sha256 cellar: :any,                 arm64_sequoia: "7130dc7e851b4d030a09a00ce75a6ac222fd75a6ca0761711ceadc0fd1feac45"
    sha256 cellar: :any,                 arm64_sonoma:  "a69ced65cdbeab062dc473a392e128fd9caf1b9a5478080026cd7e41432edb17"
    sha256 cellar: :any,                 sonoma:        "eeab3fffba67c2ab8efc748fac02158828b489e67a7d3d99e71e183ef1d2961d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2682eb7a77112f2544a450a797dde005750988cc584e027914e8a5069f1b4748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27d7ec72021cea4c654091c60d647901d83b5ab12a56b128b94f809bb9024f9f"
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
    pth_contents = "import site; site.addsitedir('#{Formula["pytorch"].opt_libexec/site_packages}')\n"
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
