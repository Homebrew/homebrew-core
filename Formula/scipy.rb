class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/a8/e3/4ec401f609d34162b7023a09165da491630879e4cfa2336667fe2102cd06/scipy-1.9.0.tar.gz"
  sha256 "c0dfd7d2429452e7e94904c6a3af63cbaa3cf51b348bd9d35b42db7e9ad42791"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/scipy/scipy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "4c867a7422c43a0ed345bf750aa814da0f62e595f869f63123e8a0208002c4ac"
    sha256 cellar: :any, arm64_big_sur:  "9ec777d8c2c8e206299f165abb4301c7f760033a1d39e19948af712b1247030c"
    sha256 cellar: :any, monterey:       "6957bc36c9e382f0499360074cca9f766987af9b8a090bdef4a865d2f86bba52"
    sha256 cellar: :any, big_sur:        "a3e2099d840c99496bb4d4d38128f196454fc2271a87e18b50369e534c99c237"
    sha256 cellar: :any, catalina:       "32eca5ced3e8d639229be580b574ad745e431fbfb3478b096625fe688a4836f5"
    sha256               x86_64_linux:   "ad75b05c0b089ed090dd9eb152e7ab44b5e5d13fedbfa3ce040cf2b3cd5e0bcc"
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
