class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      tag:      "v1.7.6",
      revision: "36eb41c960483c8b52b44082663c99e6a0de440a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "04d72cbe85a1a802e07408742e5b64b9312a7320789118413a29103438474dd1"
    sha256 cellar: :any,                 arm64_monterey: "97bc38d310ed1c56c1e6058913444c43f5283a8a35130312a8606802e9d63672"
    sha256 cellar: :any,                 arm64_big_sur:  "0431d0005d51463623548e8113b7b8f926606b160d69459fc6c4879fd890293f"
    sha256 cellar: :any,                 ventura:        "12df562c167a27ba5e678a50a2ab72a4e786013387bf9403f6b82983eaf45a56"
    sha256 cellar: :any,                 monterey:       "0d2664d8ce124545e28c1af5bb03dd05836fb9f39c25ad3fc67287563173add8"
    sha256 cellar: :any,                 big_sur:        "48b3579a36401fa6611fe6de895754807f7eda9e3a1a7872723fa92782d549d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e91c0a44dbc2c19678aa481e1e1077007a56098c3a8beb2d7bf5d31437e0187d"
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
    # Force use of Clang on Mojave
    ENV.clang if OS.mac?

    cp_r (pkgshare/"demo"), testpath
    cd "demo/data" do
      cp "../CLI/binary_classification/mushroom.conf", "."
      system "#{bin}/xgboost", "mushroom.conf"
    end
  end
end
