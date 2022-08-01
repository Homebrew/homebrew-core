class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://files.pythonhosted.org/packages/10/09/eb417872de4d890fdbe16bf9252e8457a722478f63d3ece5f12f00826950/reorder_python_imports-3.8.2.tar.gz"
  sha256 "bc5bd5e01548423fdcf62da767b28d5df6e613b03f9f795438f72b08b75dfba8"
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
    url "https://files.pythonhosted.org/packages/5e/b1/5c8792dee3437a13d66e0518bcd6add8ec6f54a02c89ef3f14986a05016d/classify_imports-4.1.0.tar.gz"
    sha256 "69ddc4320690c26aa8baa66bf7e0fa0eecfda49d99cf71a59dee0b57dac82616"
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
