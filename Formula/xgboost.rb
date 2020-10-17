class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      tag:      "v1.2.1",
      revision: "bcb15a980f611ac0b7540ddcb55091d0ab9655aa"
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
    url "https://files.pythonhosted.org/packages/bf/e8/15aea783ea72e2d4e51e3ec365e8dc4a1a32c9e5eb3a6d695b0d58e67cdd/numpy-1.19.2.zip"
    sha256 "0d310730e1e793527065ad7dde736197b705d0e4c9999775f212b03c44a8484c"
  end

  resource "scipy" do
    url "https://files.pythonhosted.org/packages/93/63/4a566494594a13697c5d5d8a754d6e329d018ddf881520775e0229fa29ef/scipy-1.5.3.tar.gz"
    sha256 "ddae76784574cc4c172f3d5edd7308be16078dd3b977e8746860c76c195fa707"
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
