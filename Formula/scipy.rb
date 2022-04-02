class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/b4/a2/4faa34bf0cdbefd5c706625f1234987795f368eb4e97bde9d6f46860843e/scipy-1.8.0.tar.gz"
  sha256 "31d4f2d6b724bc9a98e527b5849b8a7e589bf1ea630c33aa563eda912c9ff0bd"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "2818d2eecf3d9126d53cc3629b5e06227a0ea7ea5a4a845d3dc1b81d0180b0d7"
    sha256 cellar: :any, arm64_big_sur:  "89d3d3b52108ace1c4a19671ec7b7e1bff59ae4472370b767411624f374e357d"
    sha256 cellar: :any, monterey:       "caf9212be80e0ff32f309c3dbad8861b307a8bdc0e980599eed2f408bf531c28"
    sha256 cellar: :any, big_sur:        "ae3e8196537deaf9739880873b9fe859c84229929f111a834a0ab951166d440d"
    sha256 cellar: :any, catalina:       "5e74dcfd26730a916093f9b18dee1b1bd1a6d58d52790839c4efe2f35c452ea1"
    sha256               x86_64_linux:   "b953884a721170689cec7207e3e416606a030a1e61542a83502dd643b086cc45"
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
