class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/a6/98/fceb84466a74b8fe74ce2dcc3a0a89cb7b4a689d4775e0fb4c95f335ef6a/scipy-1.11.1.tar.gz"
  sha256 "fb5b492fa035334fd249f0973cc79ecad8b09c604b42a127a677b45a9a3d4289"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cb737edb4cc8aaa4fcab6e9459aaf63822894930b79d01b11dfaf4574f02dfd6"
    sha256 cellar: :any,                 arm64_monterey: "f7aee1ea0d70dfe3143c5dbb9bebc451f5453c8cf03ff32c10c1023f779b3513"
    sha256 cellar: :any,                 arm64_big_sur:  "3cd8b3c1480d3811d581291bb155b4af5ad3ec59ee85d133f8aea5714c1cbdb1"
    sha256 cellar: :any,                 ventura:        "c3463b9ee0484ebcd82244e537fd099530216d8768fa6f69741138a2887bc166"
    sha256 cellar: :any,                 monterey:       "c0dd5208d9b5d8fd63baa3731ee3e92e2997b978afa33e20f357de9e05071be8"
    sha256 cellar: :any,                 big_sur:        "df93a51573e035179aaaa2d3a06a124720b7a962a9c297e9d29f1ff96077fd6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e352dcf10b39445b802b5243fd96f4eb201d9918ccf673d809bfa0ba2fb53719"
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
