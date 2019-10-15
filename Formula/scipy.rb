class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/df/20/2f147945396fa74b467d696e42aa55eb603d166490a8ebe4d79e54c793df/scipy-1.3.2.tar.gz"
  sha256 "a03939b431994289f39373c57bbe452974a7da724ae7f9620a1beee575434da4"
  revision 1
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
