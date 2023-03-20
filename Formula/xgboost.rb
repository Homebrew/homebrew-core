class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      tag:      "v1.7.4",
      revision: "36ad160501251336bfe69b602acc37ab3ec32d69"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7b14c010e20409a8798f06d4893bd7fb78c0352a1024e844da161da90fbf088b"
    sha256 cellar: :any,                 arm64_monterey: "db4edb482f9b550bf208e577a0f264d6c02e7753ff88d942923a83b08dc342a0"
    sha256 cellar: :any,                 arm64_big_sur:  "5b3c8a3cbdf2e5e74a0e400072eeb7b44da2a698c9597acb9c6c26c5836252ea"
    sha256 cellar: :any,                 ventura:        "143ba340e50de7e1f823c6db88eca5a7f8f39bb4e7346dd4543d937f01420785"
    sha256 cellar: :any,                 monterey:       "1f0d75eccf5fb8473cb5a734b307622afeef1aa5254c30a507e9ded236802952"
    sha256 cellar: :any,                 big_sur:        "ffd80fec8c1de3107a6260455c34d755de7b932ca7ca05f393d1fd53f4c006e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abe8ae583ef79d382d69aba8f006ae7c8e21f6c1f1f22c14f659b45ca2d28f40"
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
