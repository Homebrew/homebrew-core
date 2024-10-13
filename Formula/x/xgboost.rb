class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      tag:      "v2.1.1",
      revision: "9c9db1259240bffe9040ed7ca6e3fb2c1bda80e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a16524cd548ed9d1defc9f876f9c1969f285db57ee0eae4d5cbbaac3e96278c0"
    sha256 cellar: :any,                 arm64_sonoma:   "079cdf25dbb24f4281aefc2d9be96639998620f4573726cff02e3b311ef4f6de"
    sha256 cellar: :any,                 arm64_ventura:  "f07b673e9e91531443027a6431eff980a0d961139e619da47c65008bf6f284e7"
    sha256 cellar: :any,                 arm64_monterey: "3a6e7c9f3b47f5ba04810e44233db85776265a65a444979b218acbb9a90b8146"
    sha256 cellar: :any,                 sonoma:         "f960825b4c60be06665add54fda26b4e623a3a0e8849c4f7bcc4c4e6b08da7cd"
    sha256 cellar: :any,                 ventura:        "9a5d10ae6daf0df9b1284eb0e7b78926e3913eccdd9a98891adead4ba5228c60"
    sha256 cellar: :any,                 monterey:       "80d8b98d6b5f6cb54a8267c22930a8f54aa743efdf23622c556e0cdc3b2731d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbedd7e752cec14fb02548e07a068e9413bc7b8c8ff71e367fa1bd3f57c74f40"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1100
    depends_on "libomp"
  end

  fails_with :clang do
    build 1100
    cause <<-EOS
      clang: error: unable to execute command: Segmentation fault: 11
      clang: error: clang frontend command failed due to signal (use -v to see invocation)
      make[2]: *** [src/CMakeFiles/objxgboost.dir/tree/updater_quantile_hist.cc.o] Error 254
    EOS
  end

  # Starting in XGBoost 1.6.0, compiling with GCC 5.4.0 results in:
  # src/linear/coordinate_common.h:414:35: internal compiler error: in tsubst_copy, at cp/pt.c:13039
  # This compiler bug is fixed in more recent versions of GCC: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=80543
  # Upstream issue filed at https://github.com/dmlc/xgboost/issues/7820
  fails_with gcc: "5"

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "demo"
  end

  test do
    cp_r (pkgshare/"demo"), testpath

    (testpath/"test.cpp").write <<~EOS
      #include <xgboost/c_api.h>
      #include <iostream>

      int main() {
        std::string train_data = "#{testpath}/demo/data/agaricus.txt.train?format=libsvm";

        DMatrixHandle dtrain;
        if (XGDMatrixCreateFromFile(train_data.c_str(), 0, &dtrain) != 0) {
          std::cerr << "Failed to load training data: " << train_data << std::endl;
          std::cerr << "Last error message: " << XGBGetLastError() << std::endl;
          return 1;
        }

        // Create booster and set parameters
        BoosterHandle booster;
        if (XGBoosterCreate(&dtrain, 1, &booster) != 0) {
          std::cerr << "Failed to create booster" << std::endl;
          return 1;
        }
        if (XGBoosterSetParam(booster, "max_depth", "2") != 0) {
          std::cerr << "Failed to set parameter" << std::endl;
          return 1;
        }
        if (XGBoosterSetParam(booster, "eta", "1") != 0) {
          std::cerr << "Failed to set parameter" << std::endl;
          return 1;
        }
        if (XGBoosterSetParam(booster, "objective", "binary:logistic") != 0) {
          std::cerr << "Failed to set parameter" << std::endl;
          return 1;
        }

        // Train the model
        for (int iter = 0; iter < 10; ++iter) {
          if (XGBoosterUpdateOneIter(booster, iter, dtrain) != 0) {
            std::cerr << "Failed to update booster" << std::endl;
            return 1;
          }
        }

        // Free resources
        XGBoosterFree(booster);
        XGDMatrixFree(dtrain);

        std::cout << "Test completed successfully" << std::endl;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lxgboost", "-o", "test"
    system "./test"
  end
end
