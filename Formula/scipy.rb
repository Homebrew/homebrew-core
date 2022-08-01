class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/a8/e3/4ec401f609d34162b7023a09165da491630879e4cfa2336667fe2102cd06/scipy-1.9.0.tar.gz"
  sha256 "c0dfd7d2429452e7e94904c6a3af63cbaa3cf51b348bd9d35b42db7e9ad42791"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "f0a1f4666ddabd87d5792d1fda3d55a39f6ef5afd9035f39195e9bd85ab5b8f2"
    sha256 cellar: :any, arm64_big_sur:  "12455b8b689ff1e676583a4757fd652e09942b801782ec48b2924e0580fc0ee5"
    sha256 cellar: :any, monterey:       "6eb1696591f83c8e2919760f68ac30de707f506ecc14dfb556e4e7c4aa58e01a"
    sha256 cellar: :any, big_sur:        "f1e274c9cde5c1792d028d26771a9c469f033966d367241b0fa49711f71f4ce3"
    sha256 cellar: :any, catalina:       "71338918ad0ca02e8dc0167cd82df93df82c5995f807c7a745fb0089b846f427"
    sha256               x86_64_linux:   "c74c01f1e51ddd5ed15604f6b7a6a724299bd6389424e7806392430e06aed202"
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
