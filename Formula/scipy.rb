class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/84/a9/2bf119f3f9cff1f376f924e39cfae18dec92a1514784046d185731301281/scipy-1.10.1.tar.gz"
  sha256 "2cf9dfb80a7b4589ba4c40ce7588986d6d5cebc5457cad2c2880f6bc2d42f3a5"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "635684fb704ad676c39206977c7c2607fd7bb9fad289d37fb218b9490e8b6e9e"
    sha256 cellar: :any,                 arm64_monterey: "572e04d819600552a59be7275310181b5268ed31d5fc8c1c2f03ab6204b1158b"
    sha256 cellar: :any,                 arm64_big_sur:  "3a8850afdd1196882ece69261981c7e35ebd9a537e657cd4d85b20210021e397"
    sha256 cellar: :any,                 ventura:        "7980949f27752635295b3690565ee0b2c472c95af61baf5228c36015cdf2c70c"
    sha256 cellar: :any,                 monterey:       "e309423a2883b5331359daeb4344d48afe5372fc667f12acb2baae5171f8cc08"
    sha256 cellar: :any,                 big_sur:        "1518a1d4e629fb4dec3abf5b5a0d61880b2a96c2df1e9bd4db49b484d716c367"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0074a42b3e2e09dd725fc58fee5bceb478e7c66f0e9b94ce1ecf450672130d52"
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
