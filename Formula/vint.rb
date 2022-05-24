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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2f6b5a2666010e512d8a4709ed99ee2b3c8cf40bacd41e27e21367558c80983"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "368cbaa4c06de2c81d5b02cfd6a4b22406f06dfdaae0bf72826417fd7e8a62da"
    sha256 cellar: :any_skip_relocation, monterey:       "12ad2d969dd0a99cf3aa3e93a03616ff8b5810885901f68077dd86cbe7fed1f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b0c53105258827dd5f12137b58b2d197a4d8583a3954e03ee61973b81ead895"
    sha256 cellar: :any_skip_relocation, catalina:       "419f197b00bd85473a3db69a339636a6db467a0abb1abddf686c1826b6b53b38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0dd625e45069aca920f1097463196a533ee62584d1b1b971a9276c966c9f0d4"
  end

  depends_on "python@3.10"

  resource "ansicolor" do
    url "https://files.pythonhosted.org/packages/79/74/630817c7eb1289a1412fcc4faeca74a69760d9c9b0db94fc09c91978a6ac/ansicolor-0.3.2.tar.gz"
    sha256 "3b840a6b1184b5f1568635b1adab28147947522707d41ceba02d5ed0a0877279"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
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
