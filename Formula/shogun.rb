class Shogun < Formula
  desc "Large scale machine learning toolbox"
  homepage "http://www.shogun-toolbox.org/"
  url "http://shogun-toolbox.org/archives/shogun/releases/6.1/sources/shogun-6.1.3.tar.bz2"
  sha256 "57169dc8c05b216771c567b2ee2988f14488dd13f7d191ebc9d0703bead4c9e6"

  bottle do
    sha256 "f1a12c1e5eddcdf573f66c14ea30b2f223830557dfb996d88ae970888b1ca719" => :high_sierra
    sha256 "f15370760814b49ac5f2d6a4b5b8ce452a286ffc571251ba8da2f1e6180f6b59" => :sierra
    sha256 "0cfa0d06e772e464e8b376a7d14b79bd00a49080f4fb808de5b40fe697819115" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on :java => ["1.7+", :build]
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "arpack"
  depends_on "eigen"
  depends_on "glpk"
  depends_on "hdf5"
  depends_on "json-c"
  depends_on "lapack" if MacOS.version >= :high_sierra
  depends_on "lzo"
  depends_on "nlopt"
  depends_on "python" if MacOS.version <= :lion
  depends_on "snappy"
  depends_on "xz"

  cxxstdlib_check :skip

  # Fixes the linking of the python interface.
  # Upstream commit from 8 Jan 2018 https://github.com/shogun-toolbox/shogun/commit/ff8840ce0e
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/7bbffa4/shogun/fix_python_linking.patch"
    sha256 "2043b939c1ae8f63cdc753141488207d76ea86d79d06be7917a833cf86cd193f"
  end

  # Fixes when Accelerator framework is to be used as a LAPACK backend for
  # Eigen. CMake swallows some of the include header flags hence on some
  # versions of macOS, hence the include of <vecLib/cblas.h> will fail.
  # Upstream commit from 30 Jan 2018 https://github.com/shogun-toolbox/shogun/commit/6db834fb4ca9783b6e5adfde808d60ebfca0abc9
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/9df360c/shogun/fix_veclib.patch"
    sha256 "de7ebe4c91da9f63fc322c5785f687c0005ed8df2c70cd3e9024fbac7b6d3745"
  end

  resource "jblas" do
    url "https://mikiobraun.github.io/jblas/jars/jblas-1.2.3.jar"
    sha256 "e9328d4e96db6b839abf50d72f63626b2309f207f35d0858724a6635742b8398"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/ee/66/7c2690141c520db08b6a6f852fa768f421b0b50683b7bbcd88ef51f33170/numpy-1.14.0.zip"
    sha256 "3de643935b212307b420248018323a44ec51987a336d1d747c1322afc3c099fb"
  end

  needs :cxx11

  def install
    ENV.cxx11

    # Fix build of modular interfaces with SWIG 3.0.5 on macOS
    # https://github.com/shogun-toolbox/shogun/pull/2694
    # https://github.com/shogun-toolbox/shogun/commit/fef8937d215db7
    ENV.append_to_cflags "-D__ASSERT_MACROS_DEFINE_VERSIONS_WITHOUT_UNDERSCORES=0"

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resource("numpy").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    if MacOS.version >= :high_sierra
      ENV["LAPACKE_PATH"] = Formula["lapack"].opt_lib
    end

    libexec.install resource("jblas")

    mkdir "build" do
      system "cmake", "..", "-DBUILD_EXAMPLES=OFF",
                            "-DBUNDLE_JSON=OFF",
                            "-DBUNDLE_NLOPT=OFF",
                            "-DENABLE_TESTING=OFF",
                            "-DENABLE_COVERAGE=OFF",
                            "-DBUILD_META_EXAMPLES=OFF",
                            "-DINTERFACE_PYTHON=ON",
                            "-DINTERFACE_JAVA=ON",
                            "-DJBLAS=#{libexec}/jblas-#{resource("jblas").version}.jar",
                            "-DLIB_INSTALL_DIR=#{lib}",
                            *std_cmake_args
      system "make", "install"
    end
  end

  def caveats
    homebrew_site_packages = Language::Python.homebrew_site_packages
    user_site_packages = Language::Python.user_site_packages "python"
    <<~EOS
      If you use system python (that comes - depending on the macOS version -
      with an old version of numpy), you may need to ensure that the brewed
      packages come earlier in Python's sys.path with:
        mkdir -p #{user_site_packages}
        echo 'import sys; sys.path.insert(1, "#{homebrew_site_packages}")' >> #{user_site_packages}/homebrew.pth
    EOS
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cstdlib>
      #include <cstring>
      #include <assert.h>

      #include <shogun/base/init.h>
      #include <shogun/lib/versionstring.h>

      using namespace shogun;

      int main(int argc, char** argv)
      {
        init_shogun_with_defaults();
        assert (std::strcmp(MAINVERSION, "#{version}") == 0);
        exit_shogun();

        return EXIT_SUCCESS;
      }
    EOS

    system ENV.cxx, "-std=c++11", "-I#{include}", "test.cpp", "-o", "test",
                    "-L#{lib}", "-lshogun"
    system "./test"
  end
end
