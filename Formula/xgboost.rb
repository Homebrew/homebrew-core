class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      tag:      "v1.7.1",
      revision: "534c940a7ea50ab3b8a827546ac9908f859379f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5c9a6b40a61e41079dce30312a21e34063aa629d46954e5f6eabcb0d384d3b8f"
    sha256 cellar: :any,                 arm64_monterey: "5699f2ee005dd0b4dedbf2dd34fe5cc4791d1bdd97635cc4fe7b78b0571b9f44"
    sha256 cellar: :any,                 arm64_big_sur:  "b4656fcac167a7d25c6ac2c17da55e386ed1ab23e7ae8826f0c87d1cd3ab34db"
    sha256 cellar: :any,                 ventura:        "c135fd9335b8d53ce52cd182c4a601500b1184cf91f538ebbaf920bb67a60fbf"
    sha256 cellar: :any,                 monterey:       "e3053a67e6bffdfdc079cab28ff9702632072fa9c3167522bf9cff8a05604667"
    sha256 cellar: :any,                 big_sur:        "97ab1f489d0e9e95b9c4a91437243215b17f16c27b0e65f074caf48a770a886a"
    sha256 cellar: :any,                 catalina:       "a4303c48b289ef9de464f7994d6acdc604a0a377c701a01b108052b1261d537c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0275c44baaec5b6d38726d49a2526c3cb08a4656a133c133b941106ab2d96a83"
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
