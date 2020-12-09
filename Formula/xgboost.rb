class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      tag:      "v1.3.0",
      revision: "1bf389998383f333490155dba4608bff9ca63b42"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "51634738fabc05059dadc938b602bbd5c627e135eed4466c543f59b03c69ad86" => :big_sur
    sha256 "6458d02e2907e74a9cc7b4d6ae22d132a7dc83f37a13e79a87f409567d46bd68" => :catalina
    sha256 "bd6bdd967e100e38130b834f93b01a82c3cfa1ea6581533ffa0d897d611656c1" => :mojave
    sha256 "5ea7f8b48ded860e69166b8f7f5adedc34c7007fab4154f5d802ee126d09bc3f" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libomp"
  depends_on "numpy"
  depends_on "scipy"

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
      cp "../CLI/binary_classification/mushroom.conf", "."
      system "#{bin}/xgboost", "mushroom.conf"
    end
  end
end
