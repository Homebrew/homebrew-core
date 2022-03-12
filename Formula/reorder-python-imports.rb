class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://files.pythonhosted.org/packages/d2/f5/952d999585cb07b82b85576ce3582fdc32cf0abaf842fd43c4f9e0d259c8/reorder_python_imports-2.8.0.tar.gz"
  sha256 "435af2a6feb39de3c4b7a415079f85b4b0052d3a7ed9ea7b269b0aff725abdaf"
  license "MIT"
  head "https://github.com/asottile/reorder_python_imports.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "343379e19aba6aa25c1f2d6dba1866e08272055ea984d2271447e58570936e3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "343379e19aba6aa25c1f2d6dba1866e08272055ea984d2271447e58570936e3f"
    sha256 cellar: :any_skip_relocation, monterey:       "a475efcb40b51a5757bae8eb0485fe27c48acb828c4bc4d328476291046a65f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a475efcb40b51a5757bae8eb0485fe27c48acb828c4bc4d328476291046a65f9"
    sha256 cellar: :any_skip_relocation, catalina:       "a475efcb40b51a5757bae8eb0485fe27c48acb828c4bc4d328476291046a65f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1904f6160c11b9fdd12f740ed108225365347820e878bd5184f96a6060ee1157"
  end

  depends_on "python@3.10"

  resource "aspy.refactor-imports" do
    url "https://files.pythonhosted.org/packages/82/24/067f7b0b15736d6dd61903766d603704223ee5d34903ae827ca9e6f74829/aspy.refactor_imports-2.3.0.tar.gz"
    sha256 "5a7775b31e55a762f807c218a3f9f1a7ff1313d766605a301f2ed937cdfa242a"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/61/2c/d21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41/cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
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
