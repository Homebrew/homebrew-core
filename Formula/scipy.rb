class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/61/67/1a654b96309c991762ee9bc39c363fc618076b155fe52d295211cf2536c7/scipy-1.7.3.tar.gz"
  sha256 "ab5875facfdef77e0a47d5fd39ea178b58e60e454a4c85aa1e52fcb80db7babf"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "65af74bafefaf1c73d8eb42bc801014acdf2b056a72d265f2f8095a73ce17c59"
    sha256 cellar: :any, monterey:      "5f4a04454d7c814fedad32aff393913b9f7705f813be17365c5410a2e23cba1d"
    sha256 cellar: :any, big_sur:       "c47075e0199e904b6aa0a6bdea43c4e8abbaffc9a416cbe72a3bb7e69d80cc89"
    sha256 cellar: :any, catalina:      "5ac18b620b2ff0fddff90a01873fb0a3b4690cd62ea355e899186fec9d225cdc"
    sha256               x86_64_linux:  "2bc3f9484913df5fcbc17432cd93520b97e48665eafa86887cf9d64f0414b8a3"
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
