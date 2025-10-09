class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder-python-imports"
  url "https://files.pythonhosted.org/packages/99/4e/718d3f6cedb7062fff086e0571cf9f14c3ca9c9947d0245321091126fffb/reorder_python_imports-3.16.0.tar.gz"
  sha256 "bcc4e5e467a8833ec187e35f84f1a3e442881b3c62c265ece87677100473db43"
  license "MIT"
  head "https://github.com/asottile/reorder-python-imports.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "75e5e7eb82f552991c8a90c57e5eb35676f41c586c8445605a6c5ff82fbf555a"
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
