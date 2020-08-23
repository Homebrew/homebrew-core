class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://github.com/asottile/reorder_python_imports/archive/v2.3.5.tar.gz"
  sha256 "e5c5b77efbd3a61fc2a4ab1ad36c57445dbec4313b8177725ead98ae05f8426e"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "f82f81ae238fb1ea08d2847d85688226f665c247cee99e6928761139bd84f14a" => :catalina
    sha256 "00b8dfb9fc9de88820c7115a701a86c582fe08651130eab710216e629fa748ab" => :mojave
    sha256 "e068d759d9b9897c699e515c5a41791fd8029c990bb8bdedd2a38ce2f91122c1" => :high_sierra
  end

  depends_on "python@3.8"

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
