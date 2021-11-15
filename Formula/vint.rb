class Vint < Formula
  include Language::Python::Virtualenv

  desc "Vim script Language Lint"
  homepage "https://github.com/Vimjas/vint"
  url "https://files.pythonhosted.org/packages/9c/c7/d5fbe5f778edee83cba3aea8cc3308db327e4c161e0656e861b9cc2cb859/vim-vint-0.3.21.tar.gz"
  sha256 "5dc59b2e5c2a746c88f5f51f3fafea3d639c6b0fdbb116bb74af27bf1c820d97"
  license "MIT"
  revision 1
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
    url "https://files.pythonhosted.org/packages/e0/00/90593d0c3078760bc3ed530f3be381c16329e80a2b47b8e6230c1288ff77/ansicolor-0.2.6.tar.gz"
    sha256 "d17e1b07b9dd7ded31699fbca53ae6cd373584f9b6dcbc124d1f321ebad31f1d"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
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
