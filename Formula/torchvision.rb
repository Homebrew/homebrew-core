class Torchvision < Formula
  desc "Datasets, transforms, and models for computer vision"
  homepage "https://github.com/pytorch/vision"
  url "https://github.com/pytorch/vision/archive/v0.8.2.tar.gz"
  sha256 "9a866c3c8feb23b3221ce261e6153fc65a98ce9ceaa71ccad017016945c178bf"
  license "BSD-3-Clause"

  bottle do
    sha256 "2828abf349caac3222b45341460359d7601c004a6d49df38d2493ee807242e3d" => :big_sur
    sha256 "50c634f2f286b1fa3609b161175541df0eed6170ab7ead47af82df2e71fcc3cc" => :catalina
    sha256 "268ea6632e0e144c9950f94005901a9c1e9941f4d05a2c5714d4ba0111b50442" => :mojave
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
