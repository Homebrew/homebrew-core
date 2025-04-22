class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/b7/b9/31ba9cd990e626574baf93fbc1ac61cf9ed54faafd04c479117517661637/scipy-1.15.2.tar.gz"
  sha256 "cd58a314d92838f7e6f755c8a2167ead4f27e1fd5c1251fd54289569ef3495ec"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6e721be4b8e3634837e8f61737a7904247a34da62b1a8ca77cb7145ad9a0b17e"
    sha256 cellar: :any,                 arm64_sonoma:  "fa67300140d1d149b36483bd680b7d0036cba6d45db7714bbe8af73001e50079"
    sha256 cellar: :any,                 arm64_ventura: "b74d9fcaef8750bb473bd4c21bc93c8fa57ad0fe2cc8f6087565744ca99a1586"
    sha256 cellar: :any,                 sonoma:        "a40acc90b9484b6e321af4333440db6d1aeb8c758b5c85018d6a1eca43a43cee"
    sha256 cellar: :any,                 ventura:       "273f1a5bb4735e7c1f62d323c7314e5a66ac7bed7440f6c3736dfff5d14259c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a92f71a9aac723e2ef2d283b60c903fc5ed179c03958f9426a0f81ecc1fc9fe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12f9c5331e4c7ece19e2338b34a13ce87e0e6c1d9c1b838e0a3047ec82f4c370"
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
