class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/c4/cf/9983551a5be67a2afe7e63b47cc5609b148f4a411dff38675273d1331d74/xonsh-0.15.1.tar.gz"
  sha256 "34a6332b7a86f6fe86a74273585c59ab1f3c89292fda5a9eafe54c926bac4710"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b291b7b4d7e686cc7a081c5ecbc92fa7cd3a80d9df7a689c091269958cb20857"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aab7139919fcbb8019b94ec7ecbadb6653fb7b242b41e81c6ddf960a553b27ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8806680d3b72939ad1ca6e17fd182c7eef38b0361f722cb4ffa254ea1808db62"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d4501161cc817ac11763280e25e66d3897a60c038fa790641d66eda1397dac7"
    sha256 cellar: :any_skip_relocation, ventura:        "6538c2f32e25bbcea9844c5e490de7652de94e689eb783df826a23341c93d322"
    sha256 cellar: :any_skip_relocation, monterey:       "52cd4ad85ba2c0b1c4ed1cf085792b63047a44f52e2983898eaaff43859f87dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2300e33941f6ca3bd5c16e1ad5f90fb1f2c48c0d32ef75b3a4f9839e652a27e"
  end

  depends_on "python@3.12"

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/99/ce/172e474a87241a69baad1ce46bc8f31eae590a770cb138b9b73812c8234d/prompt_toolkit-3.0.40.tar.gz"
    sha256 "a371c06bb1d66cd499fecd708e50c0b6ae00acba9822ba33c586e2f16d1b739e"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/55/59/8bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565/pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/ff/e1/b16b16a1aa12174349d15b73fd4b87e641a8ae3fb1163e80938dbbf6ae98/setproctitle-1.3.3.tar.gz"
    sha256 "c913e151e7ea01567837ff037a23ca8740192880198b7fbb90b16d181607caae"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
