class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://github.com/scipy/scipy/releases/download/v0.19.0/scipy-0.19.0.tar.xz"
  sha256 "ed52232afb2b321a4978e39040d94bf81af90176ba64f58c4499dc305a024437"
  revision 1
  head "https://github.com/scipy/scipy.git"

  bottle do
    sha256 "26fe901e224b85e72eadd59496f466a6ae671690ae1dca722cb26e55b2152c36" => :sierra
    sha256 "b344e7c765b05c3427c36b4bdf49d59a616f9734110549b8e41621d8ca63ef51" => :el_capitan
    sha256 "e19062e7c343583e46f493a23c44650dac1fb97fd0028b9f95f6f510887cde49" => :yosemite
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
