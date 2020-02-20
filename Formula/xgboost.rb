class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      :tag      => "v1.0.0",
      :revision => "d90e7b31170b86f97eafb6b9b64027abb6881a3e"

  bottle do
    cellar :any
    sha256 "c1f4c85c24798e3e64d0c3b4312eadb89bd0c1ae057058d450bf1414c12b8925" => :catalina
    sha256 "280fe55391f3b02fd7424afbcda34bbd861175567fe7b6b8fc4e45514bc12914" => :mojave
    sha256 "f419cdc75ffc06ca1f2247474317b782031f019fa66bc7e2cba668dfc5761c9c" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libomp"

  def install
    mkdir "build" do
      libomp = Formula["libomp"]
      args = std_cmake_args
      args << "-DOpenMP_C_FLAGS=\"-Xpreprocessor -fopenmp -I#{libomp.opt_include}\""
      args << "-DOpenMP_C_LIB_NAMES=omp"
      args << "-DOpenMP_CXX_FLAGS=\"-Xpreprocessor -fopenmp -I#{libomp.opt_include}\""
      args << "-DOpenMP_CXX_LIB_NAMES=omp"
      args << "-DOpenMP_omp_LIBRARY=#{libomp.opt_lib}/libomp.dylib"

      system "cmake", *args, ".."
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
