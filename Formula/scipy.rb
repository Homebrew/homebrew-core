class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/bb/bb/944f559d554df6c9adf037aa9fc982a9706ee0e96c0d5beac701cb158900/scipy-1.7.0.tar.gz"
  sha256 "998c5e6ea649489302de2c0bc026ed34284f531df89d2bdc8df3a0d44d165739"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git"

  bottle do
    sha256               arm64_big_sur: "dca16789fc4b99cb12658372f146ef839ab64ba3c838a0aad047af8f72cf52fe"
    sha256 cellar: :any, big_sur:       "23f22153d382559a089df4cbae73ff5c4b1329add5230d135b71e8447285b952"
    sha256 cellar: :any, catalina:      "0882b3e88eb307215e7c7867716e987ddd829bbec6709b295955679a19962e82"
    sha256 cellar: :any, mojave:        "7ce61d050e7d244c9c3405dfa25c31efe50e0d7a5448003bff395aff5bd4e262"
  end

  depends_on "cython" => :build
  depends_on "pythran" => :build
  depends_on "swig" => :build
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "openblas"
  depends_on "pybind11"
  depends_on "python@3.9"

  cxxstdlib_check :skip

  fails_with gcc: "5"

  def install
    # Fix for current GCC on Big Sur, which does not like 11 as version value
    # (reported at https://github.com/iains/gcc-darwin-arm64/issues/31#issuecomment-750343944)
    ENV["MACOSX_DEPLOYMENT_TARGET"] = "11.0" if MacOS.version == :big_sur

    openblas = Formula["openblas"].opt_prefix
    ENV["ATLAS"] = "None" # avoid linking against Accelerate.framework
    ENV["BLAS"] = ENV["LAPACK"] = "#{openblas}/lib/#{shared_library("libopenblas")}"

    config = <<~EOS
      [DEFAULT]
      library_dirs = #{HOMEBREW_PREFIX}/lib
      include_dirs = #{HOMEBREW_PREFIX}/include
      [openblas]
      libraries = openblas
      library_dirs = #{openblas}/lib
      include_dirs = #{openblas}/include
    EOS

    Pathname("site.cfg").write config

    site_packages = Language::Python.site_packages("python3")
    ENV.prepend_create_path "PYTHONPATH", Formula["cython"].opt_libexec/site_packages
    ENV.prepend_create_path "PYTHONPATH", Formula["pythran"].opt_libexec/site_packages
    ENV.prepend_create_path "PYTHONPATH", Formula["numpy"].opt_prefix/site_packages
    ENV.prepend_create_path "PYTHONPATH", site_packages

    system Formula["python@3.9"].opt_bin/"python3", "setup.py", "build",
      "--fcompiler=gfortran", "--parallel=#{ENV.make_jobs}"
    system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
  end

  # cleanup leftover .pyc files from previous installs which can cause problems
  # see https://github.com/Homebrew/homebrew-python/issues/185#issuecomment-67534979
  def post_install
    rm_f Dir["#{HOMEBREW_PREFIX}/lib/python*.*/site-packages/scipy/**/*.pyc"]
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import scipy"
  end
end
