class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost/releases/download/v3.0.5/xgboost-src-3.0.5.tar.gz"
  sha256 "0776b59fad03548c447cb1e188469761241ffb3b36154dc8a59735f11d262dc2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "30d5eab5d9c6c94e6bdf3a15c5cb5864235ef72ddec54fe24e47c4d2a5ab10ae"
    sha256 cellar: :any,                 arm64_sequoia: "90283850bc034c32485d67e03523284337da40cba581d91dbe23802564ab0f34"
    sha256 cellar: :any,                 arm64_sonoma:  "414bd6df6f375bb9375b4cc1e17787a0a90e6f67462baabd8454880f8445749d"
    sha256 cellar: :any,                 arm64_ventura: "e88313cfaf68176a466251dfa116322b94c4b7eeef5606059b46ea77ef41a0e5"
    sha256 cellar: :any,                 sonoma:        "813f4f6b94b159b3f59f3714b4a192c0e78e5ef1d7851988eb8648eab168afa4"
    sha256 cellar: :any,                 ventura:       "a0722dce32c9757c1517b76a7c539d6b9fb341c5469ab9e7227a52b97514cbee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5865b829160ac961ef9c44f3bd0f6bec49e824da4bc57a6946eb6871bf76448d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aed77e5967fbbe674eb89120f7946e35f0a9ce665eaba3dc731444904d796fd3"
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
