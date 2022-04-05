class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/b4/a2/4faa34bf0cdbefd5c706625f1234987795f368eb4e97bde9d6f46860843e/scipy-1.8.0.tar.gz"
  sha256 "31d4f2d6b724bc9a98e527b5849b8a7e589bf1ea630c33aa563eda912c9ff0bd"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "3750231845bfdb26a1f4295c3f91e70b879be62e3e3b6106e537da2c2d71870f"
    sha256 cellar: :any, arm64_big_sur:  "c2dd138f5a909512fb5756196e90f2220640b9629d3474250a1632a50d6ef96b"
    sha256 cellar: :any, monterey:       "116114cd1d9a36e3646c457a758286b143f31a82be833de512421b7fe33afbed"
    sha256 cellar: :any, big_sur:        "5bc525993c6524fe61f04abfd47d6e5447ab8d7ad5c5df1baca97fbe2a3e255e"
    sha256 cellar: :any, catalina:       "637f5820cad2cff149bf8471ad431ab4593b9bf458e4f62bae134252802cc3cd"
    sha256               x86_64_linux:   "97be2faad3606d207d1def7ed58074b3223be18a0867e9061fc863c6e1a162fe"
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
