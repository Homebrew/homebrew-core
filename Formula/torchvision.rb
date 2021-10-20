class Torchvision < Formula
  desc "Datasets, transforms, and models for computer vision"
  homepage "https://github.com/pytorch/vision"
  url "https://github.com/pytorch/vision/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "4d595cf0214c8adc817f8e3cd0043a027b52b481e05d67b04f4947fcb43d4277"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 big_sur:      "538900976b4d7efd2ebc3be711c5565b2e20b5e504f84eb338e8dff4eb0aad2c"
    sha256 cellar: :any,                 catalina:     "fa859b8881a88ea26dc058759752b318a3d163b38256e3000fa5c61a0674d8f6"
    sha256 cellar: :any,                 mojave:       "f7375ac80c721fccfd1275f5d262d636d7584640507dbc3d047016dde36628aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "18daac428fa8490aa00fab8e243ffa1ae6e5d7c446f3f445f73a519a301e535d"
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
