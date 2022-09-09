class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      tag:      "v1.6.2",
      revision: "b9934246faa9a25e10a12339685dfbe56d56f70b"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "1aeec8fe6a690e23d01dd6b68df579ae368b9b390e11d00fce901cc6e9bfcdac"
    sha256 cellar: :any,                 arm64_big_sur:  "f18aea395d946633e2c9202a9febaf8b8603bd559a916dca73e42536c4c0b2b1"
    sha256 cellar: :any,                 monterey:       "a76dcfb550c66a22bc4af81b29b39174937c22890a1a10c240458066ac6c5155"
    sha256 cellar: :any,                 big_sur:        "d319a6a9f67c01d5fca092aa64e24a7c1b932ec1ce84cfb5055212997bbab38c"
    sha256 cellar: :any,                 catalina:       "30450f1da0a5057f5b15f64953ba13de0988572cc558cec67ec58e1ac14dedfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c929dfbac8cc958af26b5c9acc8029e0199a2ae7a8c948595c9665578b7839b3"
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
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib
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
