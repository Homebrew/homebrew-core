class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/ea/c8/c296904f2c852c5c129962e6ca4ba467116b08cd5b54b7180b2e77fe06b2/scipy-1.2.0.tar.gz"
  sha256 "51a2424c8ed80e60bdb9a896806e7adaf24a58253b326fbad10f80a6d06f2214"
  revision 1
  head "https://github.com/scipy/scipy.git"

  bottle do
    cellar :any
    sha256 "5da6db4ee52c220da1294131e53a03db23f35c10d9447248aa2748618b361267" => :mojave
    sha256 "9bcab7ed5a3928022bf32253abfe4faf2c94da900d279a3ad949d629d432a444" => :high_sierra
    sha256 "fda76c72ded4879fcf65f1402dc59675d0bdc9a769ea9c0bd681771a52101aeb" => :sierra
  end

  depends_on "swig" => :build
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "openblas"
  depends_on "python"
  depends_on "python@2"

  cxxstdlib_check :skip

  # https://github.com/Homebrew/homebrew-python/issues/110
  # There are ongoing problems with gcc+accelerate.
  fails_with :gcc_4_2

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

    ["python2", "python3"].each do |python|
      version = Language::Python.major_minor_version python
      ENV["PYTHONPATH"] = Formula["numpy"].opt_lib/"python#{version}/site-packages"
      ENV.prepend_create_path "PYTHONPATH", lib/"python#{version}/site-packages"
      system python, "setup.py", "build", "--fcompiler=gnu95"
      system python, *Language::Python.setup_install_args(prefix)
    end
  end

  # cleanup leftover .pyc files from previous installs which can cause problems
  # see https://github.com/Homebrew/homebrew-python/issues/185#issuecomment-67534979
  def post_install
    rm_f Dir["#{HOMEBREW_PREFIX}/lib/python*.*/site-packages/scipy/**/*.pyc"]
  end

  def caveats
    homebrew_site_packages = Language::Python.homebrew_site_packages
    user_site_packages = Language::Python.user_site_packages "python"
    <<~EOS
      If you use system python (that comes - depending on the OS X version -
      with older versions of numpy, scipy and matplotlib), you may need to
      ensure that the brewed packages come earlier in Python's sys.path with:
        mkdir -p #{user_site_packages}
        echo 'import sys; sys.path.insert(1, "#{homebrew_site_packages}")' >> #{user_site_packages}/homebrew.pth
    EOS
  end

  test do
    ["python2", "python3"].each do |python|
      system python, "-c", "import scipy"
    end
  end
end
