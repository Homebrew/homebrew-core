class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/7e/74/66de6258867beb2ef08f35f9f2ac017a52cacd5081714d239ff1a442d458/scipy-1.18.1.tar.gz"
  sha256 "52c4b7422442aba924d03ad4019852b08a92e64ea187b933135687bfe2747307"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/scipy/scipy.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "771297ca2277edab9511814291d361e92a7934ad7a5350f9c093e65cc9b4d21f"
    sha256 cellar: :any, arm64_sequoia: "ad15503e1851ec7468baf7537a620a58853c061de3c58681178cda58a8848188"
    sha256 cellar: :any, arm64_sonoma:  "cf98a5276e80718a8aae44fb6e6ea90d6ee79ffa1a69904c5861b5116e60a00b"
    sha256 cellar: :any, sonoma:        "c153a629c586f806f1ef6b4d20cd01fa24ee5e3c9ae92edfb579f5a163440075"
    sha256 cellar: :any, arm64_linux:   "c227f92ab86f40a726858cad1ec08d909221efbfc938041398faf6ee4dbe68ca"
    sha256 cellar: :any, x86_64_linux:  "875545b0526bad7d0b2c5b28c93331ea6088bd12b0ffb485dcd76d2b1a218bef"
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
