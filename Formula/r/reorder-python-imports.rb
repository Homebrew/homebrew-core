class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder-python-imports"
  url "https://files.pythonhosted.org/packages/06/0e/7d36e6213d30c2639e031992fc2afbe34a7149f1a0bc1e980c451944a0b8/reorder_python_imports-3.17.0.tar.gz"
  sha256 "be8269009c1638b09e3dea8381b25689f468a09b4fddd7adc02638386a30252b"
  license "MIT"
  head "https://github.com/asottile/reorder-python-imports.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "79d092599b3a158a00c4d27262594fcd0c535ff8b847e32d590f0be4bc47720d"
  end

  depends_on "python@3.14"

  resource "classify-imports" do
    url "https://files.pythonhosted.org/packages/b5/ac/1223bc31ef2947227fe8c705efd005e6d06170cff33db3ccaef34ab98b69/classify_imports-4.5.0.tar.gz"
    sha256 "83af69ba9d4d05dd15146848d7b2cfa900a8f5cc81f26693688af73e8b199497"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      from os import path
      import sys
    PYTHON
    system bin/"reorder-python-imports", "--exit-zero-even-if-changed", testpath/"test.py"
    assert_equal("import sys\nfrom os import path\n", File.read(testpath/"test.py"))
  end
end
