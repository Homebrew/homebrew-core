class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      tag:      "v1.5.2",
      revision: "742c19f3ecf2135b4e008a4f4a10b59add8b1045"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9b9ca4c3f939578d510fea01bae8850594c240921cbc19b655fe025b6d4ffa46"
    sha256 cellar: :any,                 arm64_big_sur:  "b0a0439e94c4ed16e14d16ba8488632754fe487effb13018f8becb0a13574f38"
    sha256 cellar: :any,                 monterey:       "c47e0528f2c5a42ea1f913fcbb3d2576c15c8a2c3f35690408bc4f8dadfc9c01"
    sha256 cellar: :any,                 big_sur:        "6bf653fccf01ed326c70fed93fa272597822c08729ae853f9834bbdce8f5cc7a"
    sha256 cellar: :any,                 catalina:       "bf5082214644433977b24ef7886ea05d2632c6608b99c44dd1594ed793135731"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "713e931729b4c640ac8044c98c1f0604a99373fcd7ed81fd610e6f04cf79853e"
  end

  depends_on "cmake" => :build
  depends_on "libomp"
  depends_on "numpy"
  depends_on "scipy"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<-EOS
      clang: error: unable to execute command: Segmentation fault: 11
      clang: error: clang frontend command failed due to signal (use -v to see invocation)
      make[2]: *** [src/CMakeFiles/objxgboost.dir/tree/updater_quantile_hist.cc.o] Error 254
    EOS
  end

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
