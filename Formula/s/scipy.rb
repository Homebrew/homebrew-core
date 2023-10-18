class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/39/7b/9f265b7f074195392e893a5cdc66116c2f7a31fd5f3d9cceff661ec6df82/scipy-1.11.3.tar.gz"
  sha256 "bba4d955f54edd61899776bad459bf7326e14b9fa1c552181f0479cc60a568cd"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ebe5a63603e24a4ca17131c957e72f93aa49bc101c8c08798c1f57e12405915a"
    sha256 cellar: :any,                 arm64_ventura:  "c001e62674458c5875cf06f301c86ab9b14d4e71a7e24eaaa83ec908aba8d716"
    sha256 cellar: :any,                 arm64_monterey: "cfe4ada39860d229ea94632e6c7292a9192ab0a3e77c4c516fd247dda5bd8c2d"
    sha256 cellar: :any,                 sonoma:         "a9fb9a36174436e19ba946afec394f6b404835580115ff8d84d6be7d2eab12ba"
    sha256 cellar: :any,                 ventura:        "d6b1da45259ebd8cda4b6258b848f88b55a2bd8f7cfa29949facd7279c33c735"
    sha256 cellar: :any,                 monterey:       "cd2528d95402ca7608e07e976a7dc67bbec2a68f4876ea52a4fed23d2f20e30b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb9ce8dabb7b29350e92e51a0192907f4f65bc3fa9e428ad5daa212ce065bfe9"
  end

  depends_on "libcython" => :build
  depends_on "meson" => :build
  depends_on "meson-python" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "pythran" => :build
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "openblas"
  depends_on "pybind11"
  depends_on "python@3.11"
  depends_on "xsimd"

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
    ENV.prepend_path "PATH", Formula["libcython"].opt_libexec/"bin"
    ENV.prepend_path "PYTHONPATH", Formula["libcython"].opt_libexec/site_packages
    ENV.prepend_path "PYTHONPATH", Formula["pythran"].opt_libexec/site_packages
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_prefix/site_packages
    ENV.prepend_create_path "PYTHONPATH", site_packages

    system python3, "-m", "pip", "install", *std_pip_args, "."
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
