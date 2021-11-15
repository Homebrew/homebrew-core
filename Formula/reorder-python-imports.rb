class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://files.pythonhosted.org/packages/f8/8c/447338a4a8098f28bed79b264a43fbfae4d5d70ec2cc034fc4bc4cfaa827/reorder_python_imports-2.6.0.tar.gz"
  sha256 "f4dc03142bdb57625e64299aea80e9055ce0f8b719f8f19c217a487c9fa9379e"
  license "MIT"
  revision 1
  head "https://github.com/asottile/reorder_python_imports.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9200d4865b878afb55a5a76c0ab72524a0d72d5644e9a3c21255e830185af27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9200d4865b878afb55a5a76c0ab72524a0d72d5644e9a3c21255e830185af27"
    sha256 cellar: :any_skip_relocation, monterey:       "52040315f49c7a21aff570a1abfaf3639533a0799fce504f1a3dc6e319261944"
    sha256 cellar: :any_skip_relocation, big_sur:        "52040315f49c7a21aff570a1abfaf3639533a0799fce504f1a3dc6e319261944"
    sha256 cellar: :any_skip_relocation, catalina:       "52040315f49c7a21aff570a1abfaf3639533a0799fce504f1a3dc6e319261944"
    sha256 cellar: :any_skip_relocation, mojave:         "52040315f49c7a21aff570a1abfaf3639533a0799fce504f1a3dc6e319261944"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e81637407b24856b731462f94f13aab0f200bebfa9bba1c4533402042dd18335"
  end

  depends_on "python@3.10"

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
