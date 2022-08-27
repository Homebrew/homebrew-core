class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/db/af/16906139f52bc6866c43401869ce247662739ad71afa11c6f18505eb0546/scipy-1.9.1.tar.gz"
  sha256 "26d28c468900e6d5fdb37d2812ab46db0ccd22c63baa095057871faa3a498bc9"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "3528ab6186ecf5273aded8d18d31eab44ccc92f7201d694f389a17ea481fd3bc"
    sha256 cellar: :any, arm64_big_sur:  "c76c3df52f9e7ae22aa5b867458257b327df90f39607e390e30bdb27a15459cb"
    sha256 cellar: :any, monterey:       "7c041f9662128640a2f0a44973097cf9f8aee3a0f5f167232c4a4daeeb1cd0f2"
    sha256 cellar: :any, big_sur:        "8aeb092a37958c6e0b6110e0b0e943f302cd44b1022ba1557ad925f85eda6220"
    sha256 cellar: :any, catalina:       "85237422385c8490d3c9d6b7f44d9e854508f171a6d8b66011c9710cffef4b0a"
    sha256               x86_64_linux:   "d857d59b03c3bcf5b60e7f91256a56513c983120a8224224ddf02ad5c950735e"
  end

  depends_on "libcython" => :build
  depends_on "pythran" => :build
  depends_on "swig" => :build
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "openblas"
  depends_on "pybind11"
  depends_on "python@3.10"

  cxxstdlib_check :skip

  fails_with gcc: "5"

  def install
    openblas = Formula["openblas"]
    ENV["ATLAS"] = "None" # avoid linking against Accelerate.framework
    ENV["BLAS"] = ENV["LAPACK"] = openblas.opt_lib/shared_library("libopenblas")

    config = <<~EOS
      [DEFAULT]
      library_dirs = #{HOMEBREW_PREFIX}/lib
      include_dirs = #{HOMEBREW_PREFIX}/include
      [openblas]
      libraries = openblas
      library_dirs = #{openblas.opt_lib}
      include_dirs = #{openblas.opt_include}
    EOS

    Pathname("site.cfg").write config

    site_packages = Language::Python.site_packages("python3")
    ENV.prepend_path "PYTHONPATH", Formula["libcython"].opt_libexec/site_packages
    ENV.prepend_path "PYTHONPATH", Formula["pythran"].opt_libexec/site_packages
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_prefix/site_packages
    ENV.prepend_create_path "PYTHONPATH", site_packages

    system "python3", "setup.py", "build", "--fcompiler=gfortran", "--parallel=#{ENV.make_jobs}"
    system "python3", *Language::Python.setup_install_args(prefix)
  end

  # cleanup leftover .pyc files from previous installs which can cause problems
  # see https://github.com/Homebrew/homebrew-python/issues/185#issuecomment-67534979
  def post_install
    rm_f Dir["#{HOMEBREW_PREFIX}/lib/python*.*/site-packages/scipy/**/*.pyc"]
  end

  test do
    system Formula["python@3.10"].opt_bin/"python3", "-c", "import scipy"
  end
end
