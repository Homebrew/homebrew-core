class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://files.pythonhosted.org/packages/5d/16/fac8bebf74e45c7498296f1f7cfcb11fe1b0792ff9ce2c468c94dbe742bc/reorder_python_imports-3.0.1.tar.gz"
  sha256 "a4e1c28a1bf90a7c8fa4c534058803a7956adc722137d3e54eb91536fe12ffb6"
  license "MIT"
  head "https://github.com/asottile/reorder_python_imports.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aecaa7da5f3a020decbec59f1e8d0564ae90884c903976de0f778f55d7f3ba7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aecaa7da5f3a020decbec59f1e8d0564ae90884c903976de0f778f55d7f3ba7e"
    sha256 cellar: :any_skip_relocation, monterey:       "0d4968105151ffb53ca89e47413613a42a5bc240cc10aac5e6d40e67f6f660ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d4968105151ffb53ca89e47413613a42a5bc240cc10aac5e6d40e67f6f660ac"
    sha256 cellar: :any_skip_relocation, catalina:       "0d4968105151ffb53ca89e47413613a42a5bc240cc10aac5e6d40e67f6f660ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f567420cc1dc170f016bb447604cf1e1f69afda321ab7b054ae2cbd855788d0d"
  end

  depends_on "python@3.10"

  resource "aspy.refactor-imports" do
    url "https://files.pythonhosted.org/packages/8a/f1/2cc8c8b9e4de77ee1b3ba889eeafb68ab0b38b28d856b48b821b9d361f41/aspy.refactor_imports-3.0.1.tar.gz"
    sha256 "df497c3726ee2931b03d403e58a4590f7f4e60059b115cf5df0e07e70c7c73be"
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
