class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/0a/2e/44795c6398e24e45fa0bb61c3e98de1cfea567b1b51efd3751e2f7ff9720/scipy-1.9.3.tar.gz"
  sha256 "fbc5c05c85c1a02be77b1ff591087c83bc44579c6d2bd9fb798bb64ea5e1a027"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "455c198c142f0054ae790af648812f41b29f1c3edb8fba3c1ffb49f69e527859"
    sha256 cellar: :any,                 arm64_monterey: "2512ac50b80ad92ed389dc61c94179e8160042177947e0bda7e311195b2750d6"
    sha256 cellar: :any,                 arm64_big_sur:  "c367e57dcdf1b3db85b83b457aff95dfe2554ec0ec4925d85f56624606b80121"
    sha256 cellar: :any,                 monterey:       "a5d8342faf46f4f723972fd334e6809ad6b6e7ab7fd76b3f73dc2cd77db4a7aa"
    sha256 cellar: :any,                 big_sur:        "208d32b6a8d44a72a361e28fb71323a1dee9f1f04b08b67ae294f03c00bd653e"
    sha256 cellar: :any,                 catalina:       "23ddcd03518a66cb676796fa86084fa908ed8eb8f484a281f18e94f317365376"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "893bc4b5608de2723a31aad55142f3f5920b15c0f4507cd42f8daecdfbc98dc8"
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
