class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://files.pythonhosted.org/packages/e0/46/5c6a35431b1af4fc16794b84ee8f0ced34bbff02545c1baa113d79b9739b/reorder_python_imports-2.4.0.tar.gz"
  sha256 "9a9e7774d66e9b410b619f934e8206a63dce5be26bd894f5006eb764bba6a26d"
  license "MIT"
  head "https://github.com/asottile/reorder_python_imports.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1ae86ad76f8cba467e4fecf63b16e5a22e55a941550b1f744b8f2b52f5932605"
    sha256 cellar: :any_skip_relocation, big_sur:       "c8b110e4771ac1e3cfdeecc3fab97ddc93c9d01fdc88a446de90565b5650d38e"
    sha256 cellar: :any_skip_relocation, catalina:      "c4ca883147663f15683ba9a15cdcf8ce4cf38461b8960b4e9c51c01f46adb858"
    sha256 cellar: :any_skip_relocation, mojave:        "c874eb234767394d47372378befc196e3c8f51d5ec2e56caec6c3806693e7f56"
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
