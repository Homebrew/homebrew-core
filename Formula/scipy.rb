class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/16/48/ff7026d26dfd92520f00b109333e22c05a235f0c9115a5a2d7679cdf39ef/scipy-1.6.0.tar.gz"
  sha256 "cb6dc9f82dfd95f6b9032a8d7ea70efeeb15d5b5fd6ed4e8537bb3c673580566"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/scipy/scipy.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "88893c0dfed2be91261f2f133cf54b3e47f2b409efd7c4b07b9a56047e448a52"
    sha256 cellar: :any, big_sur:       "e455afa09ec8c0043b0a33bb78a6d4bb4ae352272c873e99b86a152d17b35bb5"
    sha256 cellar: :any, catalina:      "90b72946faca9ca20e391b69f23b0911525890eb55efe4dfd931bd23c52324a5"
    sha256 cellar: :any, mojave:        "88c5ab1d7695971d20d788db4b661b0e8ead1dffda01970296df26b1bcd18713"
  end

  depends_on "swig" => :build
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "openblas"
  depends_on "pybind11"
  depends_on "python@3.9"

  cxxstdlib_check :skip

  def install
    # Fix for current GCC on Big Sur, which does not like 11 as version value
    # (reported at https://github.com/iains/gcc-darwin-arm64/issues/31#issuecomment-750343944)
    ENV["MACOSX_DEPLOYMENT_TARGET"] = "11.0" if MacOS.version == :big_sur

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

    version = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV["PYTHONPATH"] = Formula["numpy"].opt_lib/"python#{version}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", lib/"python#{version}/site-packages"
    system Formula["python@3.9"].opt_bin/"python3", "setup.py", "build", "--fcompiler=gnu95"
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
