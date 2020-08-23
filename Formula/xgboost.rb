class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      tag:      "v1.1.1",
      revision: "34408a7fdcebc0e32142ed2f52156ea65d813400"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "a80dfdb4e53157f2a5e3ff325303be7448952c80fa5db3292d1031024a36eded" => :catalina
    sha256 "7fbe70d2c3acff2901c3499ae7ce2582e44d4e944ffa1eab09ee79b7262413c3" => :mojave
    sha256 "6f40ceaac9d8aed4cbc8e52081f9d0c63ab24f5c63b38e564334a7c2c0717118" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libomp"

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
