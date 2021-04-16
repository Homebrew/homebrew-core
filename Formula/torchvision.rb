class Torchvision < Formula
  desc "Datasets, transforms, and models for computer vision"
  homepage "https://github.com/pytorch/vision"
  url "https://github.com/pytorch/vision/archive/v0.9.1.tar.gz"
  sha256 "79964773729880e0eee0e6af13f336041121d4cc8491a3e2c0e5f184cac8a718"
  license "BSD-3-Clause"

  bottle do
    sha256 big_sur:  "46554f30dfd606dc3cca8249292bc4e06f0deabaabcb28f64367fb78a352ee10"
    sha256 catalina: "e110c8a93f47571ae5d8d14c58213fbaa208f082ee6084a6ae72c37fef6d7b09"
    sha256 mojave:   "f1d68269ea0edf1bf852fb87c6a36bc7f9adc8ffa98a782ce25f24d34925f0c9"
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
    cp pkgshare/"examples/cpp/hello_world/main.cpp", testpath
    libtorch = Formula["libtorch"]
    system ENV.cxx, "-std=c++14", "main.cpp", "-o", "test",
                    "-I#{libtorch.opt_include}",
                    "-I#{libtorch.opt_include}/torch/csrc/api/include",
                    "-L#{libtorch.opt_lib}", "-ltorch", "-ltorch_cpu", "-lc10",
                    "-L#{lib}", "-ltorchvision"
    assert_match "[1, 1000]", shell_output("./test")
  end
end
