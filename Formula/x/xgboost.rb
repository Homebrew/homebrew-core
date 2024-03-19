class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      tag:      "v2.0.3",
      revision: "82d846bbeb83c652a0b1dff0e3519e67569c4a3d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4de0361eaa9fe8c4db406bd04fffa9b26beba656dcba932ee4930a3ae47610b1"
    sha256 cellar: :any,                 arm64_ventura:  "b4334170296d5d321137c0568e67ccfd06a8de05d81ebb309853e5b248ad3a9c"
    sha256 cellar: :any,                 arm64_monterey: "325fcf2bb0cad607abbc4e1ed72bb7b049f16c377132fda949740740abada67e"
    sha256 cellar: :any,                 sonoma:         "6cc753ba0a6dae6986f18c022826195a53ec44f55d0341956e1979c47bcc94ff"
    sha256 cellar: :any,                 ventura:        "81ec4896b051d60c002a193a8462bfaa76506633931e1461023977b3cb9db776"
    sha256 cellar: :any,                 monterey:       "70de85ef2475492ae4d2580e83237ac2ed9f17352b7ab978b8d3c79f5c690e59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "715837301d437d5e8c6728e2a58b3cd72ab1b9e567e837cc444ab5e324d251cc"
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
