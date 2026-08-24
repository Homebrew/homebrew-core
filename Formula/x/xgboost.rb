class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost/releases/download/v3.4.1/xgboost-src-3.4.1.tar.gz"
  sha256 "34a5cb99a67bb98b44f204767eeeae642b65a86b2ecfca60082e4d74fd4d169a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0e52eb0f1d5c50e3ffe8043bcdc705f1115d6c1822982aa1a36cb702e27bfb30"
    sha256 cellar: :any, arm64_sequoia: "740d6fd4fc1df7196a6c07200f5ed8adf8bb86e8d8deb12f94895252a32b1130"
    sha256 cellar: :any, arm64_sonoma:  "e6274464550e9f4ffaba55a9b274a2abec0b73a7ac74735040f88c8cd878b6a1"
    sha256 cellar: :any, sonoma:        "0b85787dcd179b6b52647033816b6076227d51f1265407303c55134c969b761f"
    sha256 cellar: :any, arm64_linux:   "277dc97ea4d1e9d6079ad325ff00784c9c8cf6b3be50c5d0e106bddb66d8d028"
    sha256 cellar: :any, x86_64_linux:  "2cd992cba15986d33d0adbf41d0610de7858f7f7e8bf3d5173905f3ac8d0c63f"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  def install
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
        std::string config = "{\\"uri\\": \\"" + train_data + "\\", \\"silent\\": 0}";

        DMatrixHandle dtrain;
        if (XGDMatrixCreateFromURI(config.c_str(), &dtrain) != 0) {
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
