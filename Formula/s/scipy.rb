class Scipy < Formula
  desc "Software for mathematics, science, and engineering"
  homepage "https://www.scipy.org"
  url "https://files.pythonhosted.org/packages/7e/74/66de6258867beb2ef08f35f9f2ac017a52cacd5081714d239ff1a442d458/scipy-1.18.1.tar.gz"
  sha256 "52c4b7422442aba924d03ad4019852b08a92e64ea187b933135687bfe2747307"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 1
  head "https://github.com/scipy/scipy.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e8ae830f596de5db64742e9002200e2c5dd446931329ab827699e2ea9e17b216"
    sha256 cellar: :any, arm64_tahoe:       "2c9d141fcf20b4d940ae8f6afc72f2701575fc01a43d9405c856ce6ac7de4c7b"
    sha256 cellar: :any, arm64_sequoia:     "0e257740e396f1681e4db35423db83f19233d25b2d9d4f24d57e243f0c725ed7"
    sha256 cellar: :any, arm64_linux:       "cd30b8a3e6f3b15a9c5f40a67e26c2d15c8cb9d6ba43ad04c2640eb68451ea0b"
    sha256 cellar: :any, x86_64_linux:      "4cf54564e8ae2e6700f572be36b22337c16aba90b9be7db9d76f78beda6e0f2f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "python@3.15" => [:build, :test]
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
