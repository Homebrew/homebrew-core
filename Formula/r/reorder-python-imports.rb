class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://files.pythonhosted.org/packages/47/74/f70eb17c5e8e9bee19879df5069cd749b646a29cdfe374b5b0dafd39151c/reorder_python_imports-3.10.0.tar.gz"
  sha256 "52bf76318bcfde5c6001f442c862ccf94dcdff42c0f9ec43a2ac6f23560c60bf"
  license "MIT"
  head "https://github.com/asottile/reorder_python_imports.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9c3df83f20c8c01a78a494654afdc4f47776bbcc56721f84517246a8c05d100"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9c3df83f20c8c01a78a494654afdc4f47776bbcc56721f84517246a8c05d100"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9c3df83f20c8c01a78a494654afdc4f47776bbcc56721f84517246a8c05d100"
    sha256 cellar: :any_skip_relocation, ventura:        "5a17930cc930633dfa9f3e339b89cad78202d6d11203cd65ec15ddf8e6b30175"
    sha256 cellar: :any_skip_relocation, monterey:       "5a17930cc930633dfa9f3e339b89cad78202d6d11203cd65ec15ddf8e6b30175"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a17930cc930633dfa9f3e339b89cad78202d6d11203cd65ec15ddf8e6b30175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8067554dc71b272cdde9f527693ed329c5b77692d1ffd52de12b1c74eee7fa4c"
  end

  depends_on "python@3.11"

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
