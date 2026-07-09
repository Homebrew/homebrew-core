class Torchvision < Formula
  include Language::Python::Virtualenv

  desc "Datasets, transforms, and models for computer vision"
  homepage "https://pytorch.org/vision/stable/index.html"
  url "https://github.com/pytorch/vision/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "ecc4451241c8eeadc0c88213bd65c7932c9622d1d0034254b938f25362283ee9"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8e0841a07246f24bd430c86288189c3284495e94ce4376872bfa05de456d7532"
    sha256 cellar: :any, arm64_sequoia: "9e1b10f17bbdc92b5b0d4be182718e2956bb7dabd7f3f3e1212ce57f350907e2"
    sha256 cellar: :any, arm64_sonoma:  "223585ca17562c9a05aafb65d10348b2b94fd3d7864a633d9a3d9350e5f63dab"
    sha256 cellar: :any, sonoma:        "e2fa074caa86cc678250c707f029455d42096f39ad6a3fdee0c37595df61c1d3"
    sha256 cellar: :any, arm64_linux:   "89bf1846bb8b34d1b6edc8c6f7e1e39845961ac632d215d7826af2e67d8b93d8"
    sha256 cellar: :any, x86_64_linux:  "509eee66b2ccacc7d736de4233032cd4fb0ae7828cfc69830b0daf1e47f49285"
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
