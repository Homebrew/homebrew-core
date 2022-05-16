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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "595434e77d6e9c4363dd91932a6f352b022f41d50ab62faf0bee3bcfe03b9ad8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "595434e77d6e9c4363dd91932a6f352b022f41d50ab62faf0bee3bcfe03b9ad8"
    sha256 cellar: :any_skip_relocation, monterey:       "e0c475f7fa9eeeff2e934118584dea5ed67d00ecd46131c99016f73128988911"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0c475f7fa9eeeff2e934118584dea5ed67d00ecd46131c99016f73128988911"
    sha256 cellar: :any_skip_relocation, catalina:       "e0c475f7fa9eeeff2e934118584dea5ed67d00ecd46131c99016f73128988911"
    sha256 cellar: :any_skip_relocation, mojave:         "e0c475f7fa9eeeff2e934118584dea5ed67d00ecd46131c99016f73128988911"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06273da4a3b237e1bbfecbe12595be4e02af7db2620d212ac1753a24dc776319"
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
