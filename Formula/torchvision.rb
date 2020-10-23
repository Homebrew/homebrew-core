class Torchvision < Formula
  desc "Datasets, transforms, and models for computer vision"
  homepage "https://github.com/pytorch/vision"
  url "https://github.com/pytorch/vision/archive/v0.7.0.tar.gz"
  sha256 "fa0a6f44a50451115d1499b3f2aa597e0092a07afce1068750260fa7dd2c85cb"
  license "BSD-3-Clause"
  revision 2

  bottle do
    cellar :any
    sha256 "4f2bbd59c4894c91231ee712fa412d05e0b03a6a009fba13f38219ee1c4f771f" => :catalina
    sha256 "63229b988bfed91a4ed5d4c807dd19279d7abf203573cf7cf73a921d0e623c84" => :mojave
    sha256 "271d454fdda45808a14ef2d5a29f08cf157e735f2eee480c90dd933625a22fd1" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build
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
