class Torchvision < Formula
  desc "Datasets, transforms, and models for computer vision"
  homepage "https://github.com/pytorch/vision"
  url "https://github.com/pytorch/vision/archive/v0.9.0.tar.gz"
  sha256 "9351ed92aded632f8c7f59dfadac13c191a834babe682f5785ea47e6fcf6b472"
  license "BSD-3-Clause"

  bottle do
    sha256 big_sur:  "b84e3746d1b41f1c9b92316426a829b8ff61300e16495f8940108fd4110bd081"
    sha256 catalina: "8a53cb08c3f8c860726ecbf6b51984812e9ba182775788b459dc8efe5d7376e6"
    sha256 mojave:   "be405a858ad7de52375c421a30a5f0bdcffe3d5a403577875000375503fd2d2b"
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
