class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://files.pythonhosted.org/packages/24/7a/87e253538249d4b65aa17f9bb057f4c5fc3237e71c50a517e0742db9aa53/reorder_python_imports-3.8.5.tar.gz"
  sha256 "5e018dceb889688eafd41a1b217420f810e0400f5a26c679a08f7f9de956ca3b"
  license "MIT"
  head "https://github.com/asottile/reorder_python_imports.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4af1127c4fa0e5b0d66407c10ace567c55b7ac53228bedbe31813c104f3644e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4af1127c4fa0e5b0d66407c10ace567c55b7ac53228bedbe31813c104f3644e"
    sha256 cellar: :any_skip_relocation, monterey:       "2138a7bb693852305e22a2a68c6c484c9d609bcdf904ac6f4cad6ade5511c590"
    sha256 cellar: :any_skip_relocation, big_sur:        "2138a7bb693852305e22a2a68c6c484c9d609bcdf904ac6f4cad6ade5511c590"
    sha256 cellar: :any_skip_relocation, catalina:       "2138a7bb693852305e22a2a68c6c484c9d609bcdf904ac6f4cad6ade5511c590"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02d3300898f6a246df8876a5a6ccf84b8ec14a21f570cbdb478ae87ee9150a61"
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
