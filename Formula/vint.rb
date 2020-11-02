class Vint < Formula
  include Language::Python::Virtualenv

  desc "Vim script Language Lint"
  homepage "https://github.com/Vimjas/vint"
  url "https://github.com/Vimjas/vint/archive/v0.3.21.tar.gz"
  sha256 "ebbb4ffd790324331aabf82d0b8777db8ce41d72d7c4c1c328bc099359ae06d6"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "75161a294d40430a9146e35a9e3871f3d8761cc6b60f66f8b9abd22630f8e579" => :catalina
    sha256 "aea0df6f034bcec57f8f930781fae0a48349a0910465c253f5969e429bded6a3" => :mojave
    sha256 "5174b7b0ffdcc7231efa29c69a69d13a1e8b7649016d384931135d7dc11640bd" => :high_sierra
  end

  depends_on "python@3.9"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  resource "ansicolor" do
    url "https://files.pythonhosted.org/packages/e0/00/90593d0c3078760bc3ed530f3be381c16329e80a2b47b8e6230c1288ff77/ansicolor-0.2.6.tar.gz"
    sha256 "d17e1b07b9dd7ded31699fbca53ae6cd373584f9b6dcbc124d1f321ebad31f1d"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
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
