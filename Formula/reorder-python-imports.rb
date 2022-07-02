class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://files.pythonhosted.org/packages/08/ad/98b68a155caf91ef304613fc7b5784b8963a7625a4e23231d6cf5b0d1aa6/reorder_python_imports-3.2.1.tar.gz"
  sha256 "a4988cc3de791134d8dd1e593245305219b5ab48b9e65f26a5c474320fdef4a9"
  license "MIT"
  head "https://github.com/asottile/reorder_python_imports.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c98965317e96edfa7c67452ac13af992c8450b2a389cfb4474f8138a39f04c73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c98965317e96edfa7c67452ac13af992c8450b2a389cfb4474f8138a39f04c73"
    sha256 cellar: :any_skip_relocation, monterey:       "d57cd0db9645143cb9832659388906ed72100f39c57d209659f88db44660e657"
    sha256 cellar: :any_skip_relocation, big_sur:        "d57cd0db9645143cb9832659388906ed72100f39c57d209659f88db44660e657"
    sha256 cellar: :any_skip_relocation, catalina:       "d57cd0db9645143cb9832659388906ed72100f39c57d209659f88db44660e657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6b41b8120ba7667f63ca8d0710d6a5279ec1f8ffb50921ac6bde9f49676b2f2"
  end

  depends_on "python@3.10"

  resource "classify-imports" do
    url "https://files.pythonhosted.org/packages/b5/98/9541d3f96f8754ee3f2ecf09f0689fd5d0bb097e769a0b34585425e2d316/classify_imports-4.0.2.tar.gz"
    sha256 "a1880ba36cca1a3e6efc338698685c3c93019c92ecb7cc246636abb42c621e7f"
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
