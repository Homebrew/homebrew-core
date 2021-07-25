class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/e8/7d/ca09bfc9882d5d467568f8683252130c9eacf615ab6646f3ad229865a104/xonsh-0.10.1.tar.gz"
  sha256 "00409804fc38111800dbca40274224e069e4ef5af6020c27ad58f966ca3025e3"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a789ba640efa248ae6dce5fab63d43e094e50fe2a3d6fab12a46aee3b0e8431f"
    sha256 cellar: :any_skip_relocation, big_sur:       "84a20d6b486a3bc5ce800e0980763ecefe79fd5efe1458553e5aef9581118397"
    sha256 cellar: :any_skip_relocation, catalina:      "ef5af547e8fdfa464c0ad814fbf0a880792ee58472cecdc5e20f66ea56110a57"
    sha256 cellar: :any_skip_relocation, mojave:        "47dbc76b608d3da25a4ab5dd911fcd06447571172a18a68b625619f39d5b7f83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f05be843cb6f0c783a4bd1faaba44511c104b494979a308c35666a5b2dba08d3"
  end

  depends_on "python@3.9"

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
