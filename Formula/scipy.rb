class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/26/68/84dbe18583e79e56e4cee8d00232a8dd7d4ae33bc3acf3be1c347991848f/scipy-1.6.1.tar.gz"
  sha256 "c4fceb864890b6168e79b0e714c585dbe2fd4222768ee90bc1aa0f8218691b11"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "77db460fd4323ed36fe928a1bdec4dee2e03aff74190f7d4771fd423d100e6e2"
    sha256 cellar: :any, big_sur:       "b7fa6bd0b970993177b67d5801b7d1a6a0b21ac26a9fa106da136b930a8a9834"
    sha256 cellar: :any, catalina:      "3312dead60fc9c8be4356c669be35fc6df547f79e5ad7d2205d51c07183c865e"
    sha256 cellar: :any, mojave:        "869a09d250583791715494cf5b15ab1d00060f8e9213eec08321826259fba796"
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
