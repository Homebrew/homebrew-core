class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://files.pythonhosted.org/packages/24/7a/87e253538249d4b65aa17f9bb057f4c5fc3237e71c50a517e0742db9aa53/reorder_python_imports-3.8.5.tar.gz"
  sha256 "5e018dceb889688eafd41a1b217420f810e0400f5a26c679a08f7f9de956ca3b"
  license "MIT"
  head "https://github.com/asottile/reorder_python_imports.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4dc4d39d51f98f0f1196133ff345577c694c9a91873657590347a117b8632214"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4dc4d39d51f98f0f1196133ff345577c694c9a91873657590347a117b8632214"
    sha256 cellar: :any_skip_relocation, monterey:       "3390df71227d2f07c56946ca0ca3573ee4bb1bae4b99d76094abeba5f22fc6d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "3390df71227d2f07c56946ca0ca3573ee4bb1bae4b99d76094abeba5f22fc6d7"
    sha256 cellar: :any_skip_relocation, catalina:       "3390df71227d2f07c56946ca0ca3573ee4bb1bae4b99d76094abeba5f22fc6d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d17f41a305d7a5b5d36527a8963f386551d837f2662f93d77c470cb991fec4a7"
  end

  depends_on "python@3.10"

  resource "classify-imports" do
    url "https://files.pythonhosted.org/packages/7e/b6/6cdc486fced92110a8166aa190b7d60435165119990fc2e187a56d15144b/classify_imports-4.2.0.tar.gz"
    sha256 "7abfb7ea92149b29d046bd34573d247ba6e68cc28100c801eba4af17964fc40e"
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
