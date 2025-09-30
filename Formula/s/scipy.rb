class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/4c/3b/546a6f0bfe791bbb7f8d591613454d15097e53f906308ec6f7c1ce588e8e/scipy-1.16.2.tar.gz"
  sha256 "af029b153d243a80afb6eabe40b0a07f8e35c9adc269c019f364ad747f826a6b"
  license "BSD-3-Clause"
  head "https://github.com/scipy/scipy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f96f9f685193d313639627c319be7515f7322555375f2cdae5c19f9eef23a272"
    sha256 cellar: :any,                 arm64_sequoia: "ab949c80e39fdb61080bfe88dccefe6c1c0641a02429015bf3fe808677ea5c41"
    sha256 cellar: :any,                 arm64_sonoma:  "ea167510b98d450dfc2e1c6d00e91ffac9a2020c06128af553c9bdadaa670098"
    sha256 cellar: :any,                 arm64_ventura: "ab9ab867b6ea7fd35828586614002cbf4bb1667a64b45101dc1f3a5515a499fc"
    sha256 cellar: :any,                 sonoma:        "a1afbcd18e044b2c98ae48abc5690bd6cc1d57d637c7d7bdafdb8823a799ff9a"
    sha256 cellar: :any,                 ventura:       "714f8dcd5e6349eb87ec854c46f088ab68afc31d3c43a70fa17ce5800dddc105"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9780635f8290d71c6bda522b9641d3b80b472709391eaf8fb3f6312ef64df84b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "244ac327909150d1be1ebc90cf73dc2f11ad82f9deb695805b6952bd8739bcb2"
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
