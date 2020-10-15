class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://github.com/asottile/reorder_python_imports/archive/v2.3.5.tar.gz"
  sha256 "e5c5b77efbd3a61fc2a4ab1ad36c57445dbec4313b8177725ead98ae05f8426e"
  license "MIT"
  revision 1

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
    url "https://files.pythonhosted.org/packages/57/8e/0698e10350a57d46b3bcfe8eff1d4181642fd1724073336079cb13c5cf7f/cached-property-1.5.1.tar.gz"
    sha256 "9217a59f14a5682da7c4b8829deadbfc194ac22e9908ccf7c8820234e80a1504"
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
