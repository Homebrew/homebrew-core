class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost/releases/download/v3.0.0/xgboost-src-3.0.0.tar.gz"
  sha256 "431222b47085b9c3504d77ef59cfa23ae4fe9d701085313f47217e49e8823326"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "816bbf526b721b6148e1f45f0847b5f4f3dd5112380a2b8ec51e194ba4967241"
    sha256 cellar: :any,                 arm64_sonoma:  "da1936de67d47a562398b23de44450b3478b3cbc4f61ffb143b7cb0d0294993e"
    sha256 cellar: :any,                 arm64_ventura: "171a801dd77c6307080a660c262eab6c23ad348b2cb659ba843f33c0fb0e2d39"
    sha256 cellar: :any,                 sonoma:        "7ce28b44718e3415d78bb6ef198241440cd25652e9e710377e493ea1fe8800f7"
    sha256 cellar: :any,                 ventura:       "35f94a6e6164a0bb74cba08dfc5cbea5a06f34d0e9d870313fefef4fe2e92733"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00c0d77d1d9e588d7f487fbeb676beaf83ab84d6fc39f18f084d56e5151cfaa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce3db74dd3619467a24975aa1bb2d291124f40adbda6c0c653d35a8d42cd6c5c"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1100
    depends_on "libomp"
  end

  fails_with :clang do
    build 1100
    cause <<~EOS
      clang: error: unable to execute command: Segmentation fault: 11
      clang: error: clang frontend command failed due to signal (use -v to see invocation)
      make[2]: *** [src/CMakeFiles/objxgboost.dir/tree/updater_quantile_hist.cc.o] Error 254
    EOS
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "demo"
  end

  test do
    cp_r (pkgshare/"demo"), testpath

    (testpath/"test.cpp").write <<~CPP
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
    CPP

    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lxgboost", "-o", "test"
    system "./test"
  end
end
