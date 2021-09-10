class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      tag:      "v1.4.2",
      revision: "522b8977c27b422a4cdbe1ecc59a4d57a5df2c36"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "5db187f5a6d6c66a3fd546f7d1855cdfa102c67475de1289d3ec04dd7fbedec5"
    sha256 cellar: :any,                 big_sur:       "e81b8fd6533fce3a66f0b013dfc0d3c0eede4b54d2071dc6933201d22b135f34"
    sha256 cellar: :any,                 catalina:      "919b6d95848c782d2c330a7abbb273be7dd3babd4e38395b9ab2065bcea793d0"
    sha256 cellar: :any,                 mojave:        "a0bc2283a8dfd93406e1b9449286eb4153f306c0cdea70fc88349e970ace4bf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1cd8501d05de50109670a59d23ad8d079e0b10ad5e43dc431058f02974e75fb"
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
