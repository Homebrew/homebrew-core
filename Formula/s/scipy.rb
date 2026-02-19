class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/56/3e/9cca699f3486ce6bc12ff46dc2031f1ec8eb9ccc9a320fdaf925f1417426/scipy-1.17.0.tar.gz"
  sha256 "2591060c8e648d8b96439e111ac41fd8342fdeff1876be2e19dea3fe8930454e"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5965194466362eb9804cb65c2f6018cd389f021989e622e8ce4021ddd4cf7810"
    sha256 cellar: :any,                 arm64_sequoia: "8e6eeaf8e836d23d84e3682145101f326827696a3c2ae1b6d09cecc0564d4581"
    sha256 cellar: :any,                 arm64_sonoma:  "26a865cd0e686f82cde0794f928522350f11783435dd92553de0ece4db3ca207"
    sha256 cellar: :any,                 sonoma:        "a0044ba5cb0891a780a8e4d732bb89cf6e982be4902e8848b471ecf4f18bdb32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cece144c0e76a63260e77145532f63810720e45c8f5803ae75e09cc6fa530afb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f0946bea014ec87d58d537010b8aa1ca397ac860e9dff5998be49743ba109f7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "openblas"
  depends_on "xsimd"

  on_linux do
    depends_on "patchelf" => :build
  end

  pypi_packages exclude_packages: "numpy"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python3|
      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  def post_install
    HOMEBREW_PREFIX.glob("lib/python*.*/site-packages/scipy/**/*.pyc").map(&:unlink)
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      from scipy import special
      print(special.exp10(3))
    PYTHON
    pythons.each do |python3|
      assert_equal "1000.0", shell_output("#{python3} test.py").chomp
    end
  end
end
