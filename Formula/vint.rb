class Vint < Formula
  include Language::Python::Virtualenv

  desc "Vim script Language Lint"
  homepage "https://github.com/Vimjas/vint"
  url "https://files.pythonhosted.org/packages/9c/c7/d5fbe5f778edee83cba3aea8cc3308db327e4c161e0656e861b9cc2cb859/vim-vint-0.3.21.tar.gz"
  sha256 "5dc59b2e5c2a746c88f5f51f3fafea3d639c6b0fdbb116bb74af27bf1c820d97"
  license "MIT"
  revision 2
  head "https://github.com/Vimjas/vint.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d2fa3224e879167c8908d86811c9fb83900055a35dac7a3d47f448ddd014e1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b84f191c3c9b90fc07f82836076c7809328c2fd008a2a84c4694d67106a25eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b84f191c3c9b90fc07f82836076c7809328c2fd008a2a84c4694d67106a25eb"
    sha256 cellar: :any_skip_relocation, monterey:       "d8d2ea2896fd08da1c23fa6016a78598e1aa81f6f30abbb7eb45be920aabc228"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8d2ea2896fd08da1c23fa6016a78598e1aa81f6f30abbb7eb45be920aabc228"
    sha256 cellar: :any_skip_relocation, catalina:       "d8d2ea2896fd08da1c23fa6016a78598e1aa81f6f30abbb7eb45be920aabc228"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50f2d9de8e57fd3ae81db361024bb46032f4cc43deab51532d9343ac258e0aae"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "ansicolor" do
    url "https://files.pythonhosted.org/packages/79/74/630817c7eb1289a1412fcc4faeca74a69760d9c9b0db94fc09c91978a6ac/ansicolor-0.3.2.tar.gz"
    sha256 "3b840a6b1184b5f1568635b1adab28147947522707d41ceba02d5ed0a0877279"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/31/a2/12c090713b3d0e141f367236d3a8bdc3e5fca0d83ff3647af4892c16c205/chardet-5.0.0.tar.gz"
    sha256 "0368df2bfd78b5fc20572bb4e9bb7fb53e2c094f60ae9993339e8671d0afb8aa"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"vint", "--help"
    (testpath/"bad.vim").write <<~EOS
      not vimscript
    EOS
    assert_match "E492", shell_output("#{bin}/vint bad.vim", 1)

    (testpath/"good.vim").write <<~EOS
      " minimal vimrc
      syntax on
      set backspace=indent,eol,start
      filetype plugin indent on
    EOS
    assert_equal "", shell_output("#{bin}/vint good.vim")
  end
end
