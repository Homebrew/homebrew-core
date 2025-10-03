class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder-python-imports"
  url "https://files.pythonhosted.org/packages/74/37/3bbc2ca9e90dcc4d22b210cc1cb9f8871696d62641f539b9ed043999118b/reorder_python_imports-3.15.0.tar.gz"
  sha256 "c9a5d6027213a0b76ba42f13d16224de98cfe100b9f959e617c5a1576360fb90"
  license "MIT"
  head "https://github.com/asottile/reorder-python-imports.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "60a5c4874fe039ea50a85d1cb5ca3eb465220be116ebb63de2d0025874961d53"
  end

  depends_on "python@3.13"

  resource "classify-imports" do
    url "https://files.pythonhosted.org/packages/7e/b6/6cdc486fced92110a8166aa190b7d60435165119990fc2e187a56d15144b/classify_imports-4.2.0.tar.gz"
    sha256 "7abfb7ea92149b29d046bd34573d247ba6e68cc28100c801eba4af17964fc40e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      from os import path
      import sys
    PYTHON
    system bin/"reorder-python-imports", "--exit-zero-even-if-changed", "#{testpath}/test.py"
    assert_equal("import sys\nfrom os import path\n", File.read(testpath/"test.py"))
  end
end
