class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://files.pythonhosted.org/packages/b1/f4/e1fdaa0c5d9e64e0c8bb2a82215c15bc878406c0cd74ba2365403d4e06cb/reorder_python_imports-3.8.3.tar.gz"
  sha256 "cb622aa0ea505972b59cc01aa26c08fb17d39a8fc62ff488288908725927d968"
  license "MIT"
  head "https://github.com/asottile/reorder_python_imports.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "baf8f137e875276923bd2167401b52eeb2df7715c654b76e9b1c16a66c6f6648"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "baf8f137e875276923bd2167401b52eeb2df7715c654b76e9b1c16a66c6f6648"
    sha256 cellar: :any_skip_relocation, monterey:       "3687696735f22b0e5838fa0e4db525f3962142711d3f6304f74491d3c9ec6673"
    sha256 cellar: :any_skip_relocation, big_sur:        "3687696735f22b0e5838fa0e4db525f3962142711d3f6304f74491d3c9ec6673"
    sha256 cellar: :any_skip_relocation, catalina:       "3687696735f22b0e5838fa0e4db525f3962142711d3f6304f74491d3c9ec6673"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65fb42511e1d0e968558715f5eed66a141c442a82570685602a3d3780fca4436"
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
