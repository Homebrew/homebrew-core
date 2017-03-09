class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://github.com/scipy/scipy/releases/download/v0.19.0/scipy-0.19.0.tar.xz"
  sha256 "ed52232afb2b321a4978e39040d94bf81af90176ba64f58c4499dc305a024437"
  head "https://github.com/scipy/scipy.git"

  bottle do
    sha256 "07ce1e43b9985be7728cd5e381bbcf4cd523d3fabbb309385ef14020874b8d2e" => :sierra
    sha256 "21a66c03485a690bd4768099aedfe8b3830a7806d82f7f82c5b0e242a7bb8d36" => :el_capitan
    sha256 "821b54bc33725fdb46970ef2cba2d7fc68492fe930078d2ba1b5d3303af7ba8f" => :yosemite
  end

  option "without-python", "Build without python2 support"

  depends_on "swig" => :build
  depends_on :python => :recommended if MacOS.version <= :snow_leopard
  depends_on :python3 => :optional
  depends_on :fortran

  numpy_options = []
  numpy_options << "with-python3" if build.with? "python3"
  depends_on "numpy" => numpy_options

  cxxstdlib_check :skip

  # https://github.com/Homebrew/homebrew-python/issues/110
  # There are ongoing problems with gcc+accelerate.
  fails_with :gcc

  def install
    config = <<-EOS.undent
      [DEFAULT]
      library_dirs = #{HOMEBREW_PREFIX}/lib
      include_dirs = #{HOMEBREW_PREFIX}/include
    EOS

    Pathname("site.cfg").write config

    # gfortran is gnu95
    Language::Python.each_python(build) do |python, version|
      ENV["PYTHONPATH"] = Formula["numpy"].opt_lib/"python#{version}/site-packages"
      ENV.prepend_create_path "PYTHONPATH", lib/"python#{version}/site-packages"
      system python, "setup.py", "build", "--fcompiler=gnu95"
      system python, *Language::Python.setup_install_args(prefix)
    end
  end

  # cleanup leftover .pyc files from previous installs which can cause problems
  # see https://github.com/Homebrew/homebrew-python/issues/185#issuecomment-67534979
  def post_install
    Language::Python.each_python(build) do |_python, version|
      rm_f Dir["#{HOMEBREW_PREFIX}/lib/python#{version}/site-packages/scipy/**/*.pyc"]
    end
  end

  def caveats
    if (build.with? "python") && !Formula["python"].installed?
      homebrew_site_packages = Language::Python.homebrew_site_packages
      user_site_packages = Language::Python.user_site_packages "python"
      <<-EOS.undent
        If you use system python (that comes - depending on the OS X version -
        with older versions of numpy, scipy and matplotlib), you may need to
        ensure that the brewed packages come earlier in Python's sys.path with:
          mkdir -p #{user_site_packages}
          echo 'import sys; sys.path.insert(1, "#{homebrew_site_packages}")' >> #{user_site_packages}/homebrew.pth
      EOS
    end
  end

  test do
    system "python", "-c", "import scipy"
  end
end
