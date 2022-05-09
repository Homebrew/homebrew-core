class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      tag:      "v1.6.1",
      revision: "5d92a7d936fc3fad4c7ecb6031c3c1c7da882a14"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "721b6e870791839e65ada2ca6d5e2bf02c818fcdfcfe740250d4ae976d7d94f3"
    sha256 cellar: :any,                 arm64_big_sur:  "7496d56f10525a7428f0451f46b7e7b8411ee7d3e938670d7acd698bd33af3dc"
    sha256 cellar: :any,                 monterey:       "d4163fd468ab44c2ba6fc865917cd056a2fe7cfe7630d52c507f864b1509fb14"
    sha256 cellar: :any,                 big_sur:        "17c9a274de3696f51ece3fbd7716eaac90fa66270766cf971cc135de360d8e14"
    sha256 cellar: :any,                 catalina:       "466918f6aa2ad906408316364f82006da0597fb899d43a276fcb8eea952276a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d57f2def0d9f7bc3e0c3eed666f41757709e46bb3c05b3a7c00993183085623"
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
