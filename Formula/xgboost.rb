class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      tag:      "v1.2.0",
      revision: "738786680b65b6f7716e9db2ae60161c6121926f"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "c8d19350dfc4643d4336a58c88a405edc804c1b0513c83b50cb5a72a89c8dc32" => :catalina
    sha256 "be8665b0eb41df7319746c723d438241ccca5b28847524193ceb6a37a5708a77" => :mojave
    sha256 "2d0116ba64bcfdc82f00a3da16bd243a59ddd970fb661e095891451668533f6e" => :high_sierra
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
