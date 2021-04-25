class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://files.pythonhosted.org/packages/c3/3d/6f5b808f08f9d65e9534b2b92cb9ab051d0ccc2fd3dfa0e1b196862dcfb3/reorder_python_imports-2.5.0.tar.gz"
  sha256 "7b8bd21cacc78be5674cc7f9a3fbeb63404f810ec3cbdd6b10f87e2dbb62f7cf"
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
    url "https://files.pythonhosted.org/packages/a9/e9/cabb3bd114aa24877084f2bb6ecad8bd77f87724d239d360efd08f6fe9db/aspy.refactor_imports-2.2.0.tar.gz"
    sha256 "78ca24122963fd258ebfc4a8dc708d23a18040ee39dca8767675821e84e9ea0a"
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
