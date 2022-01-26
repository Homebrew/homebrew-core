class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://files.pythonhosted.org/packages/0f/0e/af881028b7bcb296d8982425555865a3e76ec4df13d57a0e602864594403/reorder_python_imports-2.7.1.tar.gz"
  sha256 "1ae34422f13f5a4b4669f340774909d721bfc0a8311973c70b3a50540b595bc5"
  license "MIT"
  head "https://github.com/asottile/reorder_python_imports.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93158d96d4167de3ec9ab06425e38fcaf55eb468543eb557069678fd976660b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93158d96d4167de3ec9ab06425e38fcaf55eb468543eb557069678fd976660b4"
    sha256 cellar: :any_skip_relocation, monterey:       "bbfde8321b875ca00153451dc63a1c82410e3df90eb4f6b5ef13d4b2517c9461"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbfde8321b875ca00153451dc63a1c82410e3df90eb4f6b5ef13d4b2517c9461"
    sha256 cellar: :any_skip_relocation, catalina:       "bbfde8321b875ca00153451dc63a1c82410e3df90eb4f6b5ef13d4b2517c9461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b29597f500f39ad3e64489fd2783a884faa3d8021e521fd3184340697a9b20a3"
  end

  depends_on "python@3.10"

  resource "aspy.refactor-imports" do
    url "https://files.pythonhosted.org/packages/63/e3/74f8042eb50fe161cd08cb94bc93f17a05fe76c387aeb22087db03e8173e/aspy.refactor_imports-2.2.1.tar.gz"
    sha256 "f5b2fcbf9fd68361168588f14eda64d502d029eefe632d15094cd0683ae12984"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/61/2c/d21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41/cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write <<~EOS
      from os import path
      import sys
    EOS
    system "#{bin}/reorder-python-imports", "--exit-zero-even-if-changed", "#{testpath}/test.py"
    assert_equal("import sys\nfrom os import path\n", File.read(testpath/"test.py"))
  end
end
