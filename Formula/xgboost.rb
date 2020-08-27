class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      tag:      "v1.2.0",
      revision: "738786680b65b6f7716e9db2ae60161c6121926f"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "a80dfdb4e53157f2a5e3ff325303be7448952c80fa5db3292d1031024a36eded" => :catalina
    sha256 "7fbe70d2c3acff2901c3499ae7ce2582e44d4e944ffa1eab09ee79b7262413c3" => :mojave
    sha256 "6f40ceaac9d8aed4cbc8e52081f9d0c63ab24f5c63b38e564334a7c2c0717118" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libomp"

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/2c/2f/7b4d0b639a42636362827e611cfeba67975ec875ae036dd846d459d52652/numpy-1.19.1.zip"
    sha256 "b8456987b637232602ceb4d663cb34106f7eb780e247d51a260b84760fd8f491"
  end

  resource "scipy" do
    url "https://files.pythonhosted.org/packages/53/10/776750d57ade26522478a92a2e14035868624a6a62f4157b0cc5abd4a980/scipy-1.5.2.tar.gz"
    sha256 "066c513d90eb3fd7567a9e150828d39111ebd88d3e924cdfc9f8ce19ab6f90c9"
  end

  def install
    mkdir "build" do
      system "cmake", *std_cmake_args, ".."
      system "make"
      system "make", "install"
    end
    pkgshare.install "demo"
  end

  test do
    cp_r (pkgshare/"demo"), testpath
    cd "demo/data" do
      cp "../binary_classification/mushroom.conf", "."
      system "#{bin}/xgboost", "mushroom.conf"
    end
  end
end
