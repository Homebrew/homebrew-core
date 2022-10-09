class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/17/07/68df07679ec4a4a24bff00147a14908aa73e9e8912d142886e8d0e1e3d64/scipy-1.9.2.tar.gz"
  sha256 "99e7720caefb8bca6ebf05c7d96078ed202881f61e0c68bd9e0f3e8097d6f794"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "eb6578a423f0d00416c3c5447174eb35a602cd603a6546a40cae70fe040682b0"
    sha256 cellar: :any, arm64_big_sur:  "2e9f46e809492c5b0c701d20f712f4238a7b86b7e42778963fc3d2cb6d63696b"
    sha256 cellar: :any, monterey:       "d421491023e80bad4be3da789a847993818ddfb0bf06c074db0b20120b855039"
    sha256 cellar: :any, big_sur:        "b2168d5dbbef232c844a155039e2f6e86f19ddfca2065063616f2f06faed6934"
    sha256 cellar: :any, catalina:       "eaa71d7f7bf55ddff604048ccec41e5d2640224fdde4ee9c62e0a8f9bc1248c8"
    sha256               x86_64_linux:   "1d4efe1f0132710ecbb2e89be57c106ef7f13be2c7b69009df6f0e9046b675e1"
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

  def python3
    "python3.10"
  end

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

    site_packages = Language::Python.site_packages(python3)
    ENV.prepend_path "PYTHONPATH", Formula["libcython"].opt_libexec/site_packages
    ENV.prepend_path "PYTHONPATH", Formula["pythran"].opt_libexec/site_packages
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_prefix/site_packages
    ENV.prepend_create_path "PYTHONPATH", site_packages

    system python3, "setup.py", "build", "--fcompiler=gfortran", "--parallel=#{ENV.make_jobs}"
    system python3, *Language::Python.setup_install_args(prefix, python3)
  end

  # cleanup leftover .pyc files from previous installs which can cause problems
  # see https://github.com/Homebrew/homebrew-python/issues/185#issuecomment-67534979
  def post_install
    rm_f Dir["#{HOMEBREW_PREFIX}/lib/python*.*/site-packages/scipy/**/*.pyc"]
  end

  test do
    system python3, "-c", "import scipy"
  end
end
