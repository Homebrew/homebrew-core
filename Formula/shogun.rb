class Shogun < Formula
  desc "Large scale machine learning toolbox"
  homepage "https://www.shogun-toolbox.org/"
  url "https://github.com/shogun-toolbox/shogun.git",
      tag:      "shogun_6.1.4",
      revision: "ab274e7ab6bf24dd598c1daf1e626cb686d6e1cc"
  license "BSD-3-Clause"
  revision 9

  bottle do
    sha256 "49ac9da60471784899b9b0196fa61a4c39207a394390c6378aa277353ea04a8f" => :big_sur
    sha256 "eae00812c3eed017f7c1050f5e7e61204e1e7265b035df950421eec5b2a8aa6f" => :arm64_big_sur
    sha256 "fe1fc1cf9ba0258878ca5de58d0cae01316c251aba845dccc9d9c3210ee7662d" => :catalina
    sha256 "9ca5f6e9705d9774ef7954e40af5ad47dbc0434b1dc51e2bff2823add0445052" => :mojave
  end

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
