class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/7f/3d/a29fe1f9dc61502a0cdee70e4bd4f97164106975209b6feaa2e064d241fc/xonsh-0.9.25.tar.gz"
  sha256 "20af3480d6ac1b8a48f03288796b16a35f498f047e3472c300e4ef5a26f03d60"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "adf5638b08a02469fda9b604245892717519c3e2e6672f2a0d45fde285e235b6"
    sha256 cellar: :any_skip_relocation, big_sur:       "f452f1a1bb8d5d47fcc882a8fc9819b39a38570e4b5a5aa259569f974e88619e"
    sha256 cellar: :any_skip_relocation, catalina:      "c32fcc12a0c3e00d98929d4d2a31f7d3c890ac5210a48a17087eb3e854af7982"
    sha256 cellar: :any_skip_relocation, mojave:        "3ef62348b98b48176fb167fefc2097bb88fc5c0d4194c895234f72e86f79101c"
  end

  depends_on "python@3.9"

  # Resources based on `pip3 install xonsh[ptk,pygments,proctitle]`
  # See https://xon.sh/osx.html#dependencies

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/b1/46/4eb242362c43cf033b4ec4d7205612c46c9f904a8984cdfdb64d35476175/prompt_toolkit-3.0.14.tar.gz"
    sha256 "7e966747c18ececaec785699626b771c1ba8344c8d31759a1915d6b12fad6525"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/e1/86/8059180e8217299079d8719c6e23d674aadaba0b1939e25e0cc15dcf075b/Pygments-2.7.4.tar.gz"
    sha256 "df49d09b498e83c1a73128295860250b0b7edd4c723a32e9bc0d295c7c2ec337"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/6f/4c/0b1d507ad7e8bc31d690d04b4f475e74c2002d060f7994ce8c09612df707/pyperclip-1.8.1.tar.gz"
    sha256 "9abef1e79ce635eb62309ecae02dfb5a3eb952fa7d6dce09c1aef063f81424d3"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/a1/7f/a1d4f4c7b66f0fc02f35dc5c85f45a8b4e4a7988357a29e61c14e725ef86/setproctitle-1.2.2.tar.gz"
    sha256 "7dfb472c8852403d34007e01d6e3c68c57eb66433fb8a5c77b13b89a160d97df"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
