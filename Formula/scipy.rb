class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/fe/fd/8704c7b7b34cdac850485e638346025ca57c5a859934b9aa1be5399b33b7/scipy-1.6.3.tar.gz"
  sha256 "a75b014d3294fce26852a9d04ea27b5671d86736beb34acdfc05859246260707"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/scipy/scipy.git"

  bottle do
    sha256               arm64_big_sur: "dca16789fc4b99cb12658372f146ef839ab64ba3c838a0aad047af8f72cf52fe"
    sha256 cellar: :any, big_sur:       "23f22153d382559a089df4cbae73ff5c4b1329add5230d135b71e8447285b952"
    sha256 cellar: :any, catalina:      "0882b3e88eb307215e7c7867716e987ddd829bbec6709b295955679a19962e82"
    sha256 cellar: :any, mojave:        "7ce61d050e7d244c9c3405dfa25c31efe50e0d7a5448003bff395aff5bd4e262"
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
