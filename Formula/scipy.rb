class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/fd/bd/86b03ed778e0428db4fec584ee43846d1017c46425679b45869a7c5fc021/scipy-1.5.0.tar.gz"
  sha256 "4ff72877d19b295ee7f7727615ea8238f2d59159df0bdd98f91754be4a2767f0"
  revision 1
  head "https://github.com/scipy/scipy.git"

  bottle do
    cellar :any
    sha256 "0f0120345fc26234606b9c4ad4a82f57853b8c1b0bcdcb5f2a1acadd32868bf3" => :catalina
    sha256 "579071f49a51dd26c9d9ae7ff1eefe8932277747642accccf84bd286b5504c28" => :mojave
    sha256 "77e44c7c1ae45d22a66fe6298be9dd8b9ed1ad51e0e401c71fd95d9ed44690ac" => :high_sierra
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
