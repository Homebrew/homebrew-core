class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      tag:      "v1.7.3",
      revision: "ccf43d4ba0a94e2f0a3cc5a526197539ae46f410"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "53e46f692cde8457e35dcf31b1d865b7844f5401520e33ddfb09b0a083569832"
    sha256 cellar: :any,                 arm64_monterey: "39046bb6a4be1f463ed06042e72ae3225c2d6909cadb182d443065edfdf518d5"
    sha256 cellar: :any,                 arm64_big_sur:  "6372a82c9368d60e00b3fae48e143efef1d508d3e1cefb12cbf33336fafb1d65"
    sha256 cellar: :any,                 ventura:        "9137577f46c3885bcc2af949c00e62603589ed61547a76a779650ba93483d246"
    sha256 cellar: :any,                 monterey:       "2452aba47e27bb835ae348760d2b64f9beed4b2bdfc2cfddd52519b912a24def"
    sha256 cellar: :any,                 big_sur:        "a586c0f0877c587b404fbd4f4e628e6fce46353b6698e1544390e3d59af2a999"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3610699576ad5ab08985223780139956f2d1c155bc3ecea9eab290ae7ab8f3b"
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
