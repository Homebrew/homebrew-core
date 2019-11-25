class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/a7/5c/495190b8c7cc71977c3d3fafe788d99d43eeb4740ac56856095df6a23fbd/scipy-1.3.3.tar.gz"
  sha256 "64bf4e8ae0db2d42b58477817f648d81e77f0b381d0ea4427385bba3f959380a"
  head "https://github.com/scipy/scipy.git"

  bottle do
    cellar :any
    sha256 "7da0580acb4ae66ff2d84fc8cdbc83a828b498fdd060e6c257755d22a08a3cfd" => :catalina
    sha256 "27382ea2cd1b636c4ce18187c3027d19bfbcbde978d286cf31f58e535501a2f5" => :mojave
    sha256 "95bab403776f3ae5b8770e8da1ce08e5c2b4f29fe3fb7282ca5db9e647302d78" => :high_sierra
  end

  depends_on "swig" => :build
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "openblas"
  depends_on "python"

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

    version = Language::Python.major_minor_version "python3"
    ENV["PYTHONPATH"] = Formula["numpy"].opt_lib/"python#{version}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", lib/"python#{version}/site-packages"
    system "python3", "setup.py", "build", "--fcompiler=gnu95"
    system "python3", *Language::Python.setup_install_args(prefix)
  end

  # cleanup leftover .pyc files from previous installs which can cause problems
  # see https://github.com/Homebrew/homebrew-python/issues/185#issuecomment-67534979
  def post_install
    rm_f Dir["#{HOMEBREW_PREFIX}/lib/python*.*/site-packages/scipy/**/*.pyc"]
  end

  test do
    system "python3", "-c", "import scipy"
  end
end
