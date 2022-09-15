class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/83/60/53c3c65c3bc24cf951a560faace99ee71fed34ff4e5c49e98cd797b2a0f2/xonsh-0.13.2.tar.gz"
  sha256 "92524e9ce36327182ec4619b895618a6f13eba2cd0ccfec7bacde0c3cff3dfac"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac68acb38c06a89deff7a331e2716a801bacfbb438fead1dd43f98ea85d8b842"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed8a3d1cfb9f404d12ed49c3231f99746782f2c48194f07220c47916e021e587"
    sha256 cellar: :any_skip_relocation, monterey:       "7a1a946444ad412794e78e55194e6fabfb4aad8c6416eeb6592c36940674fa47"
    sha256 cellar: :any_skip_relocation, big_sur:        "78e23ea07953af3f30965f7b167cf63855acac59c8541efcffcb5202586f05b9"
    sha256 cellar: :any_skip_relocation, catalina:       "1698625cee7a69e15fa90d872e633b35f5b03a61272cf05278432c6e73325156"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c6908e3689ceaebae474caf132b984562a7a2462197b004cf252cefb998a123"
  end

  depends_on "python@3.10"

  # Resources based on `pip3 install xonsh[ptk,pygments,proctitle]`
  # See https://xon.sh/osx.html#dependencies

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/80/76/c94cf323ca362dd7baca8d8ddf3b5fe1576848bc0156522ad581c04f8446/prompt_toolkit-3.0.31.tar.gz"
    sha256 "9ada952c9d1787f52ff6d5f3484d0b4df8952787c087edf6a1f7c2cb1ea88148"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/e0/ef/5905cd3642f2337d44143529c941cc3a02e5af16f0f65f81cbef7af452bb/Pygments-2.13.0.tar.gz"
    sha256 "56a8508ae95f98e2b9bdf93a6be5ae3f7d8af858b43e02c5a2ff083726be40c1"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/b5/47/ac709629ddb9779fee29b7d10ae9580f60a4b37e49bce72360ddf9a79cdc/setproctitle-1.3.2.tar.gz"
    sha256 "b9fb97907c830d260fa0658ed58afd48a86b2b88aac521135c352ff7fd3477fd"
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
