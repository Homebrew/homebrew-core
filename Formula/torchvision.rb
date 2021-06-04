class Torchvision < Formula
  desc "Datasets, transforms, and models for computer vision"
  homepage "https://github.com/pytorch/vision"
  url "https://github.com/pytorch/vision/archive/v0.9.1.tar.gz"
  sha256 "79964773729880e0eee0e6af13f336041121d4cc8491a3e2c0e5f184cac8a718"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any, big_sur:  "7271571ca3225e67248db0c57517149d7c7ab44f83356533daf14c6d4bcc908b"
    sha256 cellar: :any, catalina: "bffc19f93cd4f9b8ac39f0297747358fd6d573755b1585f8e553791bb115a9da"
    sha256 cellar: :any, mojave:   "b51b1077faf60c5a9795e239a168330ef25db8852e0277a1de745cc3dbfd1a53"
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
