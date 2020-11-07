class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://github.com/asottile/reorder_python_imports/archive/v2.3.6.tar.gz"
  sha256 "33df7db05db1557c743ddb3fe24cbf2d5d29bb56c3e42cb41383a242c8a213db"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "a99c24a8f52bc9c1803e594d4c62f090eb9977a873dfb196bf2be944d56e193d" => :catalina
    sha256 "524ef0d9f2ae793062d28c3e85eee754d0d5f30667c5c5ee36b7d3f886e43e9e" => :mojave
    sha256 "cbe113673b47a06b68e67bb2d2d36ee4cda1f69a6c4f51c5bdc40137859e4675" => :high_sierra
  end

  depends_on "python@3.9"

  resource "aspy.refactor-imports" do
    url "https://files.pythonhosted.org/packages/34/6e/37cbfba703b06fca29c38079bef76cc01e8496197701fff8f0dded3b5b38/aspy.refactor_imports-2.1.1.tar.gz"
    sha256 "eec8d1a73bedf64ffb8b589ad919a030c1fb14acf7d1ce0ab192f6eedae895c5"
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
