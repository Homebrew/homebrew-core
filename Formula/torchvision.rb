class Torchvision < Formula
  desc "Datasets, transforms, and models for computer vision"
  homepage "https://github.com/pytorch/vision"
  url "https://github.com/pytorch/vision/archive/v0.8.1.tar.gz"
  sha256 "c46734c679c99f93e5c06654f4295a05a6afe6c00a35ebd26a2cce507ae1ccbd"
  license "BSD-3-Clause"
  revision 1

  bottle do
    cellar :any
    sha256 "b7ea7ba92a690bfa11b27aa93d243529b1ce94e1a158640a9ae17426b3ae239c" => :catalina
    sha256 "b03ed26442db0062b053b002d87c5d7fa6eba027ec0c4513308a4a7cc8531a93" => :mojave
    sha256 "2c2c0792ddfa25e706f04d1339ea350cc44118cf57daaecf26d5d59442bc57e9" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build
  depends_on "jpeg"
  depends_on "libpng"
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
    assert_match "[1, 1000]", shell_output("./test")
  end
end
