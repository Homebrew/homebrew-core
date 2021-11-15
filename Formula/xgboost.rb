class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      tag:      "v1.5.0",
      revision: "584b45a9cca23340b756578b8a87377e5fc5ba8e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "3f1e8f289733cf64f8adb7a92db18709680659e0a46f42d9f224a56237d5e5ac"
    sha256 cellar: :any,                 monterey:      "fdae6f196d251432a21e8fb9358db09919cd0252b0c1d06aa92f40ccea509b1f"
    sha256 cellar: :any,                 big_sur:       "fa3a0b06fda339b4df1d9c42d4cb0e2b0645670d08a32a071edd55d512883b96"
    sha256 cellar: :any,                 catalina:      "33ddba64fd315c61d60dabd6eb520b26ea7692e8c50ef361ca150f7f7e26cad4"
    sha256 cellar: :any,                 mojave:        "0e0082761fbb1dada05c3498bae6e329c60b1ad6a4d1c288fa3e3f805412e456"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbcfa1bc15eec3a02476c1a9172cd3355ffb2de563bb82ef9aaa733e88527abc"
  end

  depends_on "cmake" => :build
  depends_on "libomp"
  depends_on "numpy"
  depends_on "scipy"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<-EOS
      clang: error: unable to execute command: Segmentation fault: 11
      clang: error: clang frontend command failed due to signal (use -v to see invocation)
      make[2]: *** [src/CMakeFiles/objxgboost.dir/tree/updater_quantile_hist.cc.o] Error 254
    EOS
  end

  def install
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    mkdir "build" do
      system "cmake", *std_cmake_args, ".."
      system "make"
      system "make", "install"
    end
    pkgshare.install "demo"
  end

  test do
    # Force use of Clang on Mojave
    ENV.clang if OS.mac?

    cp_r (pkgshare/"demo"), testpath
    cd "demo/data" do
      cp "../CLI/binary_classification/mushroom.conf", "."
      system "#{bin}/xgboost", "mushroom.conf"
    end
  end
end
