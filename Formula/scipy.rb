class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/fe/fd/8704c7b7b34cdac850485e638346025ca57c5a859934b9aa1be5399b33b7/scipy-1.6.3.tar.gz"
  sha256 "a75b014d3294fce26852a9d04ea27b5671d86736beb34acdfc05859246260707"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/scipy/scipy.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7dce1e5d9307cfaeb30a53dfc87c72323978618d68a89eda216454e685e0fc69"
    sha256 cellar: :any, big_sur:       "d1ac57bbd249d083a85356af2fd9b91ab4c7dd07d7a25e482096e14721ef60fb"
    sha256 cellar: :any, catalina:      "e5826c42688f56c3fb2d5eb243c8ab521e17ea31805351517e43c1ba39b3acf7"
    sha256 cellar: :any, mojave:        "1e105e2ec9caac05214bef207cda572c57e5d7a326276688ed5cf9e6a41c027c"
  end

  depends_on "swig" => :build
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "openblas"
  depends_on "pybind11"
  depends_on "python@3.9"

  cxxstdlib_check :skip

  fails_with gcc: "5"

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
