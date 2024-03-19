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
    rebuild 4
    sha256 cellar: :any,                 arm64_sonoma:   "8b27c505ce438219954cea4c8804c8caf0a3055769853871a6405b4b9892f35b"
    sha256 cellar: :any,                 arm64_ventura:  "07f73da0912788b7e2a244329de02a4a8b48f4788c966628cdf402e56608ca25"
    sha256 cellar: :any,                 arm64_monterey: "fb1ef2807d71a58efe9d8fdd29b6b2477bbc9fbda37398b67dcbaad925b58de7"
    sha256 cellar: :any,                 sonoma:         "2799f7304f4643ddbbfe2633ddd35af7dc8a765087a6b9564b693ccaf3bfaa76"
    sha256 cellar: :any,                 ventura:        "2ceb0176ec62ed830d033f5b3a7bd5fd161b01509bab9c8f32ddd003e5ce619b"
    sha256 cellar: :any,                 monterey:       "53ad7b22ab20a7431b58f77f13aa580fea9e2a8c50d1e77c3e32f87d21d29c94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ebb92e73bde3fd79edbb7ef68a8d91b7430c323d71039e9e7b0ec11b3507f9c"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "ansicolor" do
    url "https://files.pythonhosted.org/packages/79/74/630817c7eb1289a1412fcc4faeca74a69760d9c9b0db94fc09c91978a6ac/ansicolor-0.3.2.tar.gz"
    sha256 "3b840a6b1184b5f1568635b1adab28147947522707d41ceba02d5ed0a0877279"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/c9/3d/74c56f1c9efd7353807f8f5fa22adccdba99dc72f34311c30a69627a0fad/setuptools-69.1.0.tar.gz"
    sha256 "850894c4195f09c4ed30dba56213bf7c3f21d86ed6bdaafb5df5972593bfc401"
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
