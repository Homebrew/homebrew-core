class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      tag:      "v1.7.4",
      revision: "36ad160501251336bfe69b602acc37ab3ec32d69"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e6f14b76e71f556afc6eee910eec244f9758caef083e33137d481120cb5076e5"
    sha256 cellar: :any,                 arm64_monterey: "946cb5e79efe17065c71e98b6849c2cd6e40c831f75d82d5bbdb5ed585c156ed"
    sha256 cellar: :any,                 arm64_big_sur:  "4adf1e76e737e83321caf027daa313c0bb78ac3d32d31e9703e658f14324d3d0"
    sha256 cellar: :any,                 ventura:        "ff12bccfb8e452feefc06d26066671cf5bad071063c114c28fb3008ed557d1f1"
    sha256 cellar: :any,                 monterey:       "05bcd85e69ba9891ea1d7b34bd67f96e37a739a9f4769d543e5cb60aa6e7fdbd"
    sha256 cellar: :any,                 big_sur:        "094d28591dea8c8707d647df31b676eca65287446447c164d12fffcfe8d8a4c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c1896e097948c2a8ffcfe260b18f96ef8d5dd16b846daac14b0c6d8189dad72"
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
