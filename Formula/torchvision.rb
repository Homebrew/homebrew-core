class Torchvision < Formula
  desc "Datasets, transforms, and models for computer vision"
  homepage "https://github.com/pytorch/vision"
  url "https://github.com/pytorch/vision/archive/v0.8.2.tar.gz"
  sha256 "9a866c3c8feb23b3221ce261e6153fc65a98ce9ceaa71ccad017016945c178bf"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 big_sur:  "ba517b17bc4e826b96bf22200bff8c3f3f25f282d7298166a0c9dccf10f18910"
    sha256 catalina: "7d6ff7d9f4c68ef7818d32e3d5b5ddb30f721beb57fa6cff37fe52939da7d1cf"
    sha256 mojave:   "d5e0eeb3f858cc1683d80ea5724c984a7b613706bd0ae1562524e58b2720307a"
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
