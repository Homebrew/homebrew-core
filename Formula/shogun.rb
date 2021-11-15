class Shogun < Formula
  desc "Large scale machine learning toolbox"
  homepage "https://github.com/shogun-toolbox/shogun"
  url "https://github.com/shogun-toolbox/shogun.git",
      tag:      "shogun_6.1.4",
      revision: "ab274e7ab6bf24dd598c1daf1e626cb686d6e1cc"
  license "BSD-3-Clause"
  revision 11

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "4e39c797d38f15383d76c312d84313ce3757b33d6cb42393de432db7a9ee6391"
    sha256 cellar: :any,                 big_sur:       "bfefc3fb2694eb343be5fcb54b6b922ee462f6c3f4cbe38bf7392600db03ba5d"
    sha256 cellar: :any,                 catalina:      "88ac63fbb529bf14938d9b5032aa58a6718f27a5953a47ec4498404953c982a9"
    sha256 cellar: :any,                 mojave:        "589e96815f03a551445e9817da9781e5f4613a80411cb3d42085aaa5fd491be4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1da85e8939d3f09b5d9d6d7e90b9df560ca4a14e668dfc44ff62100e022ae548"
  end

  disable! date: "2021-11-15", because: "has an incompatible license"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "eigen"
  depends_on "glpk"
  depends_on "hdf5"
  depends_on "json-c"
  depends_on "lzo"
  depends_on "nlopt"
  depends_on "openblas"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "xz"

  # Fixes when Accelerator framework is to be used as a LAPACK backend for
  # Eigen. CMake swallows some of the include header flags hence on some
  # versions of macOS, hence the include of <vecLib/cblas.h> will fail.
  # Upstream commit from 30 Jan 2018 https://github.com/shogun-toolbox/shogun/commit/6db834fb4ca9783b6e5adfde808d60ebfca0abc9
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/9df360c/shogun/fix_veclib.patch"
    sha256 "de7ebe4c91da9f63fc322c5785f687c0005ed8df2c70cd3e9024fbac7b6d3745"
  end

  # Fixes compiling with json-c 0.13.1. Shogun 6.1.3 is using the
  # deprecated json-c is_error() macro which got removed in json-c 0.13.1.
  patch do
    url "https://github.com/shogun-toolbox/shogun/commit/365ce4c4c7.patch?full_index=1"
    sha256 "0a1c3e2e16b2ce70855c1f15876bddd5e5de35ab29290afceacdf7179c4558cb"
  end

  def install
    ENV.cxx11

    args = std_cmake_args + %w[
      -DBLA_VENDOR=OpenBLAS
      -DBUILD_EXAMPLES=OFF
      -DBUILD_META_EXAMPLES=OFF
      -DBUNDLE_JSON=OFF
      -DBUNDLE_NLOPT=OFF
      -DCMAKE_DISABLE_FIND_PACKAGE_ARPREC=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_CCache=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_ColPack=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_CPLEX=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_Ctags=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_GDB=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_LpSolve=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_Mosek=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_OpenMP=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_Pandoc=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_rxcpp=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_Sphinx=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_TFLogger=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_ViennaCL=ON
      -DENABLE_COVERAGE=OFF
      -DENABLE_LTO=ON
      -DENABLE_TESTING=OFF
      -DINTERFACE_CSHARP=OFF
      -DINTERFACE_JAVA=OFF
      -DINTERFACE_LUA=OFF
      -DINTERFACE_OCTAVE=OFF
      -DINTERFACE_PERL=OFF
      -DINTERFACE_PYTHON=OFF
      -DINTERFACE_R=OFF
      -DINTERFACE_RUBY=OFF
      -DINTERFACE_SCALA=OFF
    ]

    mkdir "build" do
      system "cmake", *args, ".."
      system "make"
      system "make", "install"
    end

    inreplace lib/"cmake/shogun/ShogunTargets.cmake",
      Formula["hdf5"].prefix.realpath,
      Formula["hdf5"].opt_prefix
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cassert>
      #include <cstring>
      #include <shogun/base/init.h>
      #include <shogun/lib/versionstring.h>
      int main() {
        shogun::init_shogun_with_defaults();
        assert(std::strcmp(MAINVERSION, "#{version}") == 0);
        shogun::exit_shogun();
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "-I#{include}", "test.cpp", "-o", "test",
                    "-L#{lib}", "-lshogun"
    system "./test"
  end
end
