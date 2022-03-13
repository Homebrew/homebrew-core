class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://files.pythonhosted.org/packages/4f/98/2d6f147478a7e6c090d25adced7bc98b5ffd2febb70216812226a12def95/reorder_python_imports-3.0.0.tar.gz"
  sha256 "85252ae9ac8fbe941180c747c5cb92244b53a9c28f81199d955a76328466aa86"
  license "MIT"
  head "https://github.com/asottile/reorder_python_imports.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aecaa7da5f3a020decbec59f1e8d0564ae90884c903976de0f778f55d7f3ba7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aecaa7da5f3a020decbec59f1e8d0564ae90884c903976de0f778f55d7f3ba7e"
    sha256 cellar: :any_skip_relocation, monterey:       "0d4968105151ffb53ca89e47413613a42a5bc240cc10aac5e6d40e67f6f660ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d4968105151ffb53ca89e47413613a42a5bc240cc10aac5e6d40e67f6f660ac"
    sha256 cellar: :any_skip_relocation, catalina:       "0d4968105151ffb53ca89e47413613a42a5bc240cc10aac5e6d40e67f6f660ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f567420cc1dc170f016bb447604cf1e1f69afda321ab7b054ae2cbd855788d0d"
  end

  depends_on "python@3.10"

  resource "aspy.refactor-imports" do
    url "https://files.pythonhosted.org/packages/e9/db/0b78d95f04280e3fb8fadf477af758462c6d8ce943077c867602fca65610/aspy.refactor_imports-3.0.0.tar.gz"
    sha256 "8327b27e0060785212c75eb3ffcfad0d7b5ef3f97414bef3b64bfc7192927c8f"
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
