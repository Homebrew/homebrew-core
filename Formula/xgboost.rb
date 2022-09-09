class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      tag:      "v1.6.2",
      revision: "b9934246faa9a25e10a12339685dfbe56d56f70b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fd2698f7f9c29e995702e9ee3386e1e39c56e55d8f911cddda308cd9cee06b35"
    sha256 cellar: :any,                 arm64_big_sur:  "d75b273499bd6ac5b54ba00a862260f41e74d782d7fdcd62a918496ce5ecc79b"
    sha256 cellar: :any,                 monterey:       "9c3494bf0257aac8e7fdc8e450dffb8e6859f33acd28ee630b1bb3d3acb05339"
    sha256 cellar: :any,                 big_sur:        "7ccbe35e06184bcd73eefccea371c79768c279f2394c57e6268e75d44a8a22b4"
    sha256 cellar: :any,                 catalina:       "5385532351240cf699609734662e906561645606ed515a104fc207f577517b31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfa3fb202e126cd89f60e3286aeb24b89834f2e92cf2ed422832b67c3bf8f86a"
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
