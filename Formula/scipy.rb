class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/cb/97/361c8c6ceb3eb765371a702ea873ff2fe112fa40073e7d2b8199db8eb56e/scipy-1.3.0.tar.gz"
  sha256 "c3bb4bd2aca82fb498247deeac12265921fe231502a6bc6edea3ee7fe6c40a7a"
  revision 1
  head "https://github.com/scipy/scipy.git"

  bottle do
    cellar :any
    sha256 "6e07af108117c6dfed404844e1241368373173ce849d3b618c870c3ba602a6aa" => :catalina
    sha256 "952cee660434c8d413e10e0c3b35e742389ac5ca4cf5143a85ee9b52f8efbdf5" => :mojave
    sha256 "d7c2eadab99795a7399357baa46214580287082dda88baf04316b1df0a9d1757" => :high_sierra
    sha256 "b4451f5eacb2e3e53aa891911dfc0b0069461a9396422b1cdfae13d2444142bb" => :sierra
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
    system "python3", "-c", "import scipy"
  end
end
