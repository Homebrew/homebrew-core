class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/81/18/b06a83f0c5ee8cddbde5e3f3d0bb9b702abfa5136ef6d4620ff67df7eee5/scipy-1.16.0.tar.gz"
  sha256 "b5ef54021e832869c8cfb03bc3bf20366cbcd426e02a58e8a58d7584dfbb8f62"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "68e792894b6bb09448a409d75ad4dc0bdc0085159da3dffa6c3ae90052f86123"
    sha256 cellar: :any,                 arm64_sonoma:  "192f60b8dc9b387d6ce9a1061c3bedfca19ed3d4a5e3e206754723b95b6d88ba"
    sha256 cellar: :any,                 arm64_ventura: "7a21a95e060343afe3600e4b0b0b882c7734f8a103c9778ef8780774275ade51"
    sha256 cellar: :any,                 sonoma:        "8952115168ad99667c67f27030f72341ecfd45f4b452f37d2d5436ca30f85600"
    sha256 cellar: :any,                 ventura:       "75c13b75b1afd702e72d93d844de2a8c15e52dc01b5083065248eb5e432072a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aeafd3259c7b6d0bb1abb9dea14f9e120297948060e89f43832817f4235caa80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e677b7995f3e2652e74ae0f48840092ac67f40a79045aedebb4f0d4be3f8ae5e"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "openblas"
  depends_on "xsimd"

  on_linux do
    depends_on "patchelf" => :build
  end

  cxxstdlib_check :skip

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
