class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://files.pythonhosted.org/packages/7c/a7/d415ff9bf22885abaa7ac7a9a60ff40c598c245f7439de9a14911ac4ff84/reorder_python_imports-3.4.0.tar.gz"
  sha256 "cdbf5cd52859b6ee6d5931720984a846951a3c0b5865a00541d8f4b6c4218f6f"
  license "MIT"
  head "https://github.com/asottile/reorder_python_imports.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9985157573909d811f29ad4d1086ad2dad0f74ca2595968bf4d56679bdc8dec0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9985157573909d811f29ad4d1086ad2dad0f74ca2595968bf4d56679bdc8dec0"
    sha256 cellar: :any_skip_relocation, monterey:       "a14fd3c0d0061f275d207be4cec3dc6f044cf6cd8c980e2fd26500495e1662a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "a14fd3c0d0061f275d207be4cec3dc6f044cf6cd8c980e2fd26500495e1662a2"
    sha256 cellar: :any_skip_relocation, catalina:       "a14fd3c0d0061f275d207be4cec3dc6f044cf6cd8c980e2fd26500495e1662a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "718edd3b574d594d3ffe9f573aefd79f149158fe0f5575486fc989820e46d266"
  end

  depends_on "python@3.10"

  resource "classify-imports" do
    url "https://files.pythonhosted.org/packages/5e/b1/5c8792dee3437a13d66e0518bcd6add8ec6f54a02c89ef3f14986a05016d/classify_imports-4.1.0.tar.gz"
    sha256 "69ddc4320690c26aa8baa66bf7e0fa0eecfda49d99cf71a59dee0b57dac82616"
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
