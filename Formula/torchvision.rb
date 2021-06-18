class Torchvision < Formula
  desc "Datasets, transforms, and models for computer vision"
  homepage "https://github.com/pytorch/vision"
  url "https://github.com/pytorch/vision/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "82bb2c2b03d8a65f4ea74bb0ee5566b0876a1992aceefb1e11475c7b5d2e857b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, big_sur:  "34f138594750340d6d6a6289889c1e79af84835f29b537b4c62f0b171ef54baa"
    sha256 cellar: :any, catalina: "95db2585d9daab84fc042aaa25a8408139a180eb71f29cf72bafcf752a55f7ad"
    sha256 cellar: :any, mojave:   "5ab7dac9b945df8694ccbceeca16b08df0ff1f241917d65dfd33217d00f9568c"
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
