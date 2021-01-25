class Vint < Formula
  include Language::Python::Virtualenv

  desc "Vim script Language Lint"
  homepage "https://github.com/Vimjas/vint"
  url "https://files.pythonhosted.org/packages/9c/c7/d5fbe5f778edee83cba3aea8cc3308db327e4c161e0656e861b9cc2cb859/vim-vint-0.3.21.tar.gz"
  sha256 "5dc59b2e5c2a746c88f5f51f3fafea3d639c6b0fdbb116bb74af27bf1c820d97"
  license "MIT"
  head "https://github.com/Vimjas/vint.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8d38f90dd2dae38afef80e3b0f4b62fd90e6fe3f55bf00d1006df70e96769523" => :big_sur
    sha256 "a65f86843dc5833129a0dc1b62d32d816e956171634304ea96263b4b30f96642" => :arm64_big_sur
    sha256 "8848e8f89f352b4bbcfb875438c09e4dbae683bc1a5044b30d254ee1700ec0e3" => :catalina
    sha256 "8e4f3863fcdd29a7c727e4117dbb8731606c97ad25bf5a80ddbad65d96a43dd7" => :mojave
    sha256 "4719b1fd512613b97246d52968fe3a7dfe6d45b7c9749bad87bd22bf4841fc0d" => :high_sierra
  end

  depends_on "python@3.9"

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
