class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      tag:      "v1.6.1",
      revision: "5d92a7d936fc3fad4c7ecb6031c3c1c7da882a14"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fceacabe97ff4b138eb3067bc3231afe1af30fa388dfa671d7db6024cbb54205"
    sha256 cellar: :any,                 arm64_big_sur:  "4dfdef1e85d26bcf291d57638b4fd446c434b1b7ae2aa35c47b7ed2f63cfc52b"
    sha256 cellar: :any,                 monterey:       "a59e16026bc4305411e4d28b656c0ebad8ea9fb89407ddde848de24fcdade58e"
    sha256 cellar: :any,                 big_sur:        "edff7930532c9a798103e54675b7748c6131e223a1b64e6d33242621c791796d"
    sha256 cellar: :any,                 catalina:       "f46cfe285a917c4e66f536888291b620f7fb3b99ab38aa8f34ba10bc7dc3b867"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76644ec7af83a810fb69b95c69fc01031d87d2a5b221b9f2425d0febd224dd43"
  end

  depends_on "cmake" => :build
  depends_on "numpy"
  depends_on "scipy"

  on_macos do
    depends_on "libomp"
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1100
  end

  on_linux do
    depends_on "gcc"
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
