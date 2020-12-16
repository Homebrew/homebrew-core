class Torchvision < Formula
  desc "Datasets, transforms, and models for computer vision"
  homepage "https://github.com/pytorch/vision"
  url "https://github.com/pytorch/vision/archive/v0.8.2.tar.gz"
  sha256 "9a866c3c8feb23b3221ce261e6153fc65a98ce9ceaa71ccad017016945c178bf"
  license "BSD-3-Clause"

  bottle do
    sha256 "0100b617cbf2d6558152c7c6b749dca9c040b77eb78e7b3fb6e05f24c87bb5c0" => :big_sur
    sha256 "d66bb7cbe8121343ddeb88c1f52e01460cb130a062524f8ab073ad71da95498a" => :catalina
    sha256 "6280671d16b1e72e75994dd9028dd69102176c7c5809ccbb2be16c90a2b602e8" => :mojave
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
