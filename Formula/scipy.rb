class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/07/76/7e844757b9f3bf5ab9f951ccd3e4a8eed91ab8720b0aac8c2adcc2fdae9f/scipy-1.1.0.tar.gz"
  sha256 "878352408424dffaa695ffedf2f9f92844e116686923ed9aa8626fc30d32cfd1"
  revision 1
  head "https://github.com/scipy/scipy.git"

  bottle do
    sha256 "d5891e77142ccb6bbe8130a3c813b43ed3d104d88003ebb7eb7e429f61732f41" => :high_sierra
    sha256 "69fc81494cc88ce48d2cfce6b6a699b4791fd123d359ee1efa1baba5335ff44c" => :sierra
    sha256 "f29e13501fba93639c5eb76e9628b81b2b8fb9122c9c15da0145a2897c83ebf9" => :el_capitan
  end

  option "without-python", "Build without python2 support"

  depends_on "swig" => :build
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "python@2" => :recommended
  depends_on "python" => :recommended

  cxxstdlib_check :skip

  # https://github.com/Homebrew/homebrew-python/issues/110
  # There are ongoing problems with gcc+accelerate.
  fails_with :gcc

  def install
    config = <<~EOS
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
    if (build.with? "python@2") && !Formula["python@2"].installed?
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
  end

  test do
    Language::Python.each_python(build) do |python, _version|
      system python, "-c", "import scipy"
    end
  end
end
