class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/9c/ef/87a5565907645998d7c62e76b84b0ca9f0b7c25cd433f5617a968051cec3/scipy-1.11.2.tar.gz"
  sha256 "b29318a5e39bd200ca4381d80b065cdf3076c7d7281c5e36569e99273867f61d"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "f7787de170ca640e8c7bd39d827e559a7c042836059fb2bfc08055f656434cc5"
    sha256                               arm64_monterey: "7b67ca107ddff3187ee21f43c85da04519da5f40d833d9aef47aa9349b12e4b0"
    sha256                               arm64_big_sur:  "0cb8876bfeb7b2677793a2c1c66036434fa35b26004cbe84ebbc822ffd142af5"
    sha256                               ventura:        "cec1b1041514017e7c0bebc80a3feb3e7cb5f4618c7b3b86b3fc6c6d5d863ff4"
    sha256                               monterey:       "371e080a6f3dcfc720ed1a3bd347088689621edb31705be8081b2c22c3b1d0bc"
    sha256                               big_sur:        "1a18627dd982bbff60a3c639628660c0dc5cddfd7d90f6a33808a0c30b8a41d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38a71fc17322aba7a79cf52adad58df2c1bf3b42691a269a779a2b56d0671d46"
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
