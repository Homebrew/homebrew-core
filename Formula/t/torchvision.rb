class Torchvision < Formula
  include Language::Python::Virtualenv

  desc "Datasets, transforms, and models for computer vision"
  homepage "https://pytorch.org/vision/stable/index.html"
  url "https://github.com/pytorch/vision/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "a7ac1b3ab489d71f6e27edfad1e27616e4b8a9b1517e60fce4a950600d3510e8"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "539634362d5cc968e3f9a820c1c0dd8c2e9b7d9ac5ad81e2592cddf4426ed23a"
    sha256 cellar: :any,                 arm64_sequoia: "e0340d938d02c2c16302e8c6a5ed68bd337af67bd56a3c1192384a7e0ba4396c"
    sha256 cellar: :any,                 arm64_sonoma:  "b69e69ee7951e0936a54c6abc14ba984baf6fa8c7b2cdea0fc4c759e1309940d"
    sha256 cellar: :any,                 sonoma:        "82ccb650c5e1c4da6eb8a03e701b5907aa94c0fcd88e6eccdfa5246a0358d1a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96244faf35c835f31285e3856371b904ea0a5cbde635f5c480928447f178417e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23c3bc0afba26b0e02eb1dea014694aa5b45ea2d2d159f151f99984cd9534bc5"
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
