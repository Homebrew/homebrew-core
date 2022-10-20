class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/17/07/68df07679ec4a4a24bff00147a14908aa73e9e8912d142886e8d0e1e3d64/scipy-1.9.2.tar.gz"
  sha256 "99e7720caefb8bca6ebf05c7d96078ed202881f61e0c68bd9e0f3e8097d6f794"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "83b74bda67988fa1d08c0d35aec8ce36ad7af37124cc66cab3c4c78adade7ba0"
    sha256 cellar: :any,                 arm64_big_sur:  "d114d2c826a3f85eb14a44703862cbcacf042ed31a87279e949f5641561b6c88"
    sha256 cellar: :any,                 monterey:       "3ce97141c981a49afb26b464182609967a7d1a6a3be4378d0f2ba30def4f6889"
    sha256 cellar: :any,                 big_sur:        "fcb9ceb7956f0f32989e6260699a1e86a74e75e8e72a4974b78c252239589d13"
    sha256 cellar: :any,                 catalina:       "c3a6c976a9b925c5379a1571cdea6f363f89b58091c54850036114cd6a7b0584"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bdae00013b84afec30d278709610842f54f9eebcc410b893a4a1e7e7b5bd89b"
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
