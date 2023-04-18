class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      tag:      "v1.7.5",
      revision: "21d95f3d8f23873a76f8afaad0fee5fa3e00eafe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "67b7e5b22b31201c172219942a09618c34fb1fba2c75e9d5e3fd21fe227d9b58"
    sha256 cellar: :any,                 arm64_monterey: "4ca99905fe694f136261f9688ef17c810c54742eef298c3cf7fa530f6bd863e0"
    sha256 cellar: :any,                 arm64_big_sur:  "6a3110716c6a497ab5a293f89f05b8dc20d810a82a7613b930ea7f1e1766c519"
    sha256 cellar: :any,                 ventura:        "f30a72140f291fdb15b028ddfd69f11e82e169a70ec4c7287f4fa018f1078a86"
    sha256 cellar: :any,                 monterey:       "e9555ecd503a0e305911f26d4936e576595465f50e3aff4b35755b11db082027"
    sha256 cellar: :any,                 big_sur:        "7a4f66fc2b499a24e18a6a4ecdfcde8d58c3ded162bce7424e437fe656d6a862"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7455a514aea38251662464ea22f40b5da5e021714e69e276941d23fe9a465b2e"
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
