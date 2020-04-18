class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      :tag      => "v1.0.2",
      :revision => "917b0a7b46954e9be36cbc430a1727bb093234bb"

  bottle do
    cellar :any
    sha256 "c1f4c85c24798e3e64d0c3b4312eadb89bd0c1ae057058d450bf1414c12b8925" => :catalina
    sha256 "280fe55391f3b02fd7424afbcda34bbd861175567fe7b6b8fc4e45514bc12914" => :mojave
    sha256 "f419cdc75ffc06ca1f2247474317b782031f019fa66bc7e2cba668dfc5761c9c" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", *std_cmake_args, "-DUSE_OPENMP=0", ".."
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
