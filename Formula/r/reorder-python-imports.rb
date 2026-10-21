class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder-python-imports"
  url "https://files.pythonhosted.org/packages/1a/5a/4c37aa9e062adf680f7d93ba7c954b571feaed1984b93f2f6932ded628b3/reorder_python_imports-3.19.0.tar.gz"
  sha256 "457e65fc0adb50d724b633cae2825e484c119dc381f01353c4fe7693216451c0"
  license "MIT"
  head "https://github.com/asottile/reorder-python-imports.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e172e3e27fc03b30feb21847ce55d14b4c9f30351eddf1bc857f5676b6ae24b1"
  end

  depends_on "python@3.15"

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
