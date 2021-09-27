class Torchvision < Formula
  desc "Datasets, transforms, and models for computer vision"
  homepage "https://github.com/pytorch/vision"
  url "https://github.com/pytorch/vision/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "4d595cf0214c8adc817f8e3cd0043a027b52b481e05d67b04f4947fcb43d4277"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 big_sur:      "34f138594750340d6d6a6289889c1e79af84835f29b537b4c62f0b171ef54baa"
    sha256 cellar: :any,                 catalina:     "95db2585d9daab84fc042aaa25a8408139a180eb71f29cf72bafcf752a55f7ad"
    sha256 cellar: :any,                 mojave:       "5ab7dac9b945df8694ccbceeca16b08df0ff1f241917d65dfd33217d00f9568c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6033c883e34ea6189bb310cfb8b641b5a51c62b81f24d296ae681987c038a1ad"
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
