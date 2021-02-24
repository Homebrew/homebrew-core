class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/06/e2/e610db811c1717c9dc0f38c1039a88b746ec5c0e0249f1712703f0dd04ca/xonsh-0.9.26.tar.gz"
  sha256 "a7a4e4bdf1784e7c3e08a989538e85892481a46b0c79bac9c6cc6f7802858e01"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c60d56f621c34f1ac9a74e7efb546d14daeaa7af861387389a9b50de851f4fa2"
    sha256 cellar: :any_skip_relocation, big_sur:       "a7c6e1baa7e13f77d649886cc3fd86affaaf0faea7312f93ab0f50b4759f743f"
    sha256 cellar: :any_skip_relocation, catalina:      "97b60288e023017c4570a9e6d161646c74b1c7d78efe2053fb0879c9e7e41299"
    sha256 cellar: :any_skip_relocation, mojave:        "da8aec9b98fe5e8c8457bb6d64367993b237998a71ac641034f67a6c7d84c3a2"
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
