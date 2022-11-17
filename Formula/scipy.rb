class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/0a/2e/44795c6398e24e45fa0bb61c3e98de1cfea567b1b51efd3751e2f7ff9720/scipy-1.9.3.tar.gz"
  sha256 "fbc5c05c85c1a02be77b1ff591087c83bc44579c6d2bd9fb798bb64ea5e1a027"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/scipy/scipy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5f2d0282453b41cdbc0750d0241915aae8ddd5f578fa0991fc0f947608e59656"
    sha256 cellar: :any,                 arm64_monterey: "ff285792a40ad19198f37acd98a0175d5b7fe09d8a7b1224992f13e184d92110"
    sha256 cellar: :any,                 arm64_big_sur:  "c050d550c8d1561e24898ce83d4c11e2cfefbf2a625844c5a4b7251bca4ea290"
    sha256 cellar: :any,                 ventura:        "6291305df18f2618fba9eac317873e85df015360c4214c1cb9f348b096a6e269"
    sha256 cellar: :any,                 monterey:       "feeb8006b35425d76b509d36ed34080b6471dbc3e10d87d380a83bf70ec9259f"
    sha256 cellar: :any,                 big_sur:        "92428d7c2109237e028de547a43ce45741b84ac8febb96f75ab37b66150716ab"
    sha256 cellar: :any,                 catalina:       "42ee88e1701bf6387a1df6c69de26222e1d38f10fc0fc56dd70d7daddf48332d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "830db952065a41d1859420d39a1de97ffeedd59843c336e49bf209647513e342"
  end

  depends_on "libcython" => :build
  depends_on "pythran" => :build
  depends_on "swig" => :build
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "openblas"
  depends_on "pybind11"
  depends_on "python@3.11"

  cxxstdlib_check :skip

  fails_with gcc: "5"

  def python3
    "python3.11"
  end

  def install
    openblas = Formula["openblas"]
    ENV["ATLAS"] = "None" # avoid linking against Accelerate.framework
    ENV["BLAS"] = ENV["LAPACK"] = openblas.opt_lib/shared_library("libopenblas")

    config = <<~EOS
      [DEFAULT]
      library_dirs = #{HOMEBREW_PREFIX}/lib
      include_dirs = #{HOMEBREW_PREFIX}/include
      [openblas]
      libraries = openblas
      library_dirs = #{openblas.opt_lib}
      include_dirs = #{openblas.opt_include}
    EOS

    Pathname("site.cfg").write config

    site_packages = Language::Python.site_packages(python3)
    ENV.prepend_path "PYTHONPATH", Formula["libcython"].opt_libexec/site_packages
    ENV.prepend_path "PYTHONPATH", Formula["pythran"].opt_libexec/site_packages
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_prefix/site_packages
    ENV.prepend_create_path "PYTHONPATH", site_packages

    system python3, "setup.py", "build", "--fcompiler=gfortran", "--parallel=#{ENV.make_jobs}"
    system python3, *Language::Python.setup_install_args(prefix, python3)
  end

  # cleanup leftover .pyc files from previous installs which can cause problems
  # see https://github.com/Homebrew/homebrew-python/issues/185#issuecomment-67534979
  def post_install
    rm_f Dir["#{HOMEBREW_PREFIX}/lib/python*.*/site-packages/scipy/**/*.pyc"]
  end

  test do
    (testpath/"test.py").write <<~EOS
      from scipy import special
      print(special.exp10(3))
    EOS
    assert_equal "1000.0", shell_output("#{python3} test.py").chomp
  end
end
