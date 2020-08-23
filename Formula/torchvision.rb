class Torchvision < Formula
  desc "Datasets, transforms, and models for computer vision"
  homepage "https://github.com/pytorch/vision"
  url "https://github.com/pytorch/vision/archive/v0.7.0.tar.gz"
  sha256 "fa0a6f44a50451115d1499b3f2aa597e0092a07afce1068750260fa7dd2c85cb"
  license "BSD-3-Clause"
  revision 1

  bottle do
    cellar :any
    sha256 "161fb00bdb69732b97969ecc3131d8d4f78d624091191ad17c8905018786a72d" => :catalina
    sha256 "3d348ed59f04bda1e4dccffd531307714cbc596007b7daf96d4ac49e661db68e" => :mojave
    sha256 "03e0932e274d856c1d57938d6e4d76a5edbedcc8c7d785141b1a1177494340d2" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.8" => :build
  depends_on "libtorch"

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
    assert_match "[ CPUFloatType{1,1000} ]", shell_output("./test")
  end
end
