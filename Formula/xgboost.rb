class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      tag:      "v1.7.1",
      revision: "534c940a7ea50ab3b8a827546ac9908f859379f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3519bff1d9d50e11b0426f7e0d4c46f90472816e15d50bd43b47b3444765ab8e"
    sha256 cellar: :any,                 arm64_monterey: "bda1bab8a53816e42464af9d678031ed20429e2fbd41db80c36ccfbd7f6a20d1"
    sha256 cellar: :any,                 arm64_big_sur:  "06530ace9571079254a75a94909cdc667acba978dcf6674a75ffed633ec7c0ec"
    sha256 cellar: :any,                 monterey:       "36adf45b463ce0fa81eee86d27cf3b4fa1d7a9536cfe5a6fbee2673d94fca194"
    sha256 cellar: :any,                 big_sur:        "3c18465f87e1f96fb913207ead5c379b758eb8ce24b833a951299a1b878b88a3"
    sha256 cellar: :any,                 catalina:       "6fe1a6bdb739ecf61f8ccc64f884d8f9c3aab289618377fd4ef14f4b8e020fd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04ab14b66ecfeab0ba1dfe35b7a879e9f929abb200b12c2972dcc28b026a17e0"
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
