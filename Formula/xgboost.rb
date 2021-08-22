class Xgboost < Formula
  desc "Scalable, Portable and Distributed Gradient Boosting Library"
  homepage "https://xgboost.ai/"
  url "https://github.com/dmlc/xgboost.git",
      tag:      "v1.4.2",
      revision: "522b8977c27b422a4cdbe1ecc59a4d57a5df2c36"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "b5365cde699802720656bfa80f19f09f49825fd0f3156a7ce6c5a4cd5ccaf84d"
    sha256 cellar: :any,                 big_sur:       "42a3ec388bf05959fbd05c6b918cad2fba99a2a1812e9916e7ae9cd92dfb7af8"
    sha256 cellar: :any,                 catalina:      "b27e1a0394848b9840c09198bda4cae9bc57314ce833082f701336c434bbd4c8"
    sha256 cellar: :any,                 mojave:        "2a65f86dc8a2d9576c64a94f2296c481880482739d80dca988abf6a96e1ccf34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1969ae0696e732650a04bbc7b1de2b7ff000b47dfb251d71a8354411ceec7a87"
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
    on_macos do
      ENV.llvm_clang if DevelopmentTools.clang_build_version <= 1100
    end

    mkdir "build" do
      system "cmake", *std_cmake_args, ".."
      system "make"
      system "make", "install"
    end
    pkgshare.install "demo"
  end

  test do
    # Force use of Clang on Mojave
    on_macos { ENV.clang }

    cp_r (pkgshare/"demo"), testpath
    cd "demo/data" do
      cp "../CLI/binary_classification/mushroom.conf", "."
      system "#{bin}/xgboost", "mushroom.conf"
    end
  end
end
