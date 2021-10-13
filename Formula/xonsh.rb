class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/e8/7d/ca09bfc9882d5d467568f8683252130c9eacf615ab6646f3ad229865a104/xonsh-0.10.1.tar.gz"
  sha256 "00409804fc38111800dbca40274224e069e4ef5af6020c27ad58f966ca3025e3"
  license "BSD-2-Clause-Views"
  revision 1
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5fb3c82fca2e1ab90535bec95ca2b8a0a8b88fab228ef5359f506ec80b39390f"
    sha256 cellar: :any_skip_relocation, big_sur:       "3e7f1cce24863e1cd004aa5e48936fb3fa08221562f48a8df09a9d41d30abd65"
    sha256 cellar: :any_skip_relocation, catalina:      "2b3f5a0fec4be94ade8e795bbed189d40b170bbe6666272f2769301a10a06b7b"
    sha256 cellar: :any_skip_relocation, mojave:        "c725e454f415b326e51aa0f3b689597a7f88917997de91826e8ef234d8416d05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad63f1d5ee9d7cfe2f7ab3057133eed133ca766896d7910497d17eb23824e94e"
  end

  depends_on "python@3.10"

  # Resources based on `pip3 install xonsh[ptk,pygments,proctitle]`
  # See https://xon.sh/osx.html#dependencies

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/88/4b/2c0f9e2b52297bdeede91c8917c51575b125006da5d0485521fa2b1e0b75/prompt_toolkit-3.0.19.tar.gz"
    sha256 "08360ee3a3148bdb5163621709ee322ec34fc4375099afa4bbf751e9b7b7fa4f"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/ba/6e/7a7c13c21d8a4a7f82ccbfe257a045890d4dbf18c023f985f565f97393e3/Pygments-2.9.0.tar.gz"
    sha256 "a18f47b506a429f6f4b9df81bb02beab9ca21d0a5fee38ed15aef65f0545519f"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
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
