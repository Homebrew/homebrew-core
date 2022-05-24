class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/26/b5/9330f004b9a3b2b6a31f59f46f1617ce9ca15c0e7fe64288c20385a05c9d/scipy-1.8.1.tar.gz"
  sha256 "9e3fb1b0e896f14a85aa9a28d5f755daaeeb54c897b746df7a55ccb02b340f33"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "e70703dd223d9b678f465c268e77a892cfe2602b7f7ad9a288a8efbd65ec3c92"
    sha256 cellar: :any, arm64_big_sur:  "1382ef60f57a259d00f76239d5763f70e3ce7b922da295023ea2970068527054"
    sha256 cellar: :any, monterey:       "556d91d10b74c316dc5fdbcb3ab5382b6b4d3d4f33ea0ac4faa412155cbb75c8"
    sha256 cellar: :any, big_sur:        "5b5eafe225aceef063771c22197b882dd6b6dfd2e9a7656cd65c3967ba8f0537"
    sha256 cellar: :any, catalina:       "4484ed1e364d8175548e3f59080669f1a6563310ec3a8a355bc6130029eb3b3c"
    sha256               x86_64_linux:   "ec5adbad1bff9d60dc84e9e0b4f92f9b1dc3c25c2532e744ef78b6b3a0cae92c"
  end

  depends_on "libcython" => :build
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
    ENV.prepend_create_path "PYTHONPATH", Formula["libcython"].opt_libexec/site_packages
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
