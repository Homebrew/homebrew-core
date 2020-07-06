class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/8a/6c/7777c60626cf620ce24d6349af69f3d2a4f298729d688cc4cd9528ae3c61/scipy-1.5.1.tar.gz"
  sha256 "039572f0ca9578a466683558c5bf1e65d442860ec6e13307d528749cfe6d07b8"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git"

  bottle do
    cellar :any
    sha256 "1fbab4eeef561f870085c01f8bfd5dc49e106d40937589582fc64c721711c92e" => :catalina
    sha256 "c7082559111698830a7592e7a0d8d8c23cef28f34c878cf3fddcfa1f40e5485e" => :mojave
    sha256 "03276027fe92d926e3654c4fb6f232819c080055d659a46f1cfdf0b6f6495a4a" => :high_sierra
  end

  depends_on "swig" => :build
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "openblas"
  depends_on "pybind11"
  depends_on "python@3.8"

  cxxstdlib_check :skip

  def install
    openblas = Formula["openblas"].opt_prefix
    ENV["ATLAS"] = "None" # avoid linking against Accelerate.framework
    ENV["BLAS"] = ENV["LAPACK"] = "#{openblas}/lib/libopenblas.dylib"

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

    version = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    ENV["PYTHONPATH"] = Formula["numpy"].opt_lib/"python#{version}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", lib/"python#{version}/site-packages"
    system Formula["python@3.8"].opt_bin/"python3", "setup.py", "build", "--fcompiler=gnu95"
    system Formula["python@3.8"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
  end

  # cleanup leftover .pyc files from previous installs which can cause problems
  # see https://github.com/Homebrew/homebrew-python/issues/185#issuecomment-67534979
  def post_install
    rm_f Dir["#{HOMEBREW_PREFIX}/lib/python*.*/site-packages/scipy/**/*.pyc"]
  end

  test do
    system Formula["python@3.8"].opt_bin/"python3", "-c", "import scipy"
  end
end
