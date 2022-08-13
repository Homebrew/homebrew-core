class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/f1/c2/3ef203080c205ccecd6d1d193bd31e3d8f42daac13eb989a5a993356964f/xonsh-0.13.1.tar.gz"
  sha256 "18822664c8ae84869d5bccb1560c797cbf657024fa560caab1360602274f80ac"
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
    url "https://files.pythonhosted.org/packages/c5/7e/71693dc21d20464e4cd7c600f2d8fad1159601a42ed55566500272fe69b5/prompt_toolkit-3.0.30.tar.gz"
    sha256 "859b283c50bde45f5f97829f77a4674d1c1fcd88539364f1b28a37805cfd89c0"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/59/0f/eb10576eb73b5857bc22610cdfc59e424ced4004fe7132c8f2af2cc168d3/Pygments-2.12.0.tar.gz"
    sha256 "5eb116118f9612ff1ee89ac96437bb6b49e8f04d8a13b514ba26f620208e26eb"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/a6/66/c302b8d6920eaa0274a5d88072c9dc64726306f8cfb4d90d3fc17a994ffc/setproctitle-1.3.1.tar.gz"
    sha256 "3d134c2effeb945e8227f7d3d24ea8ad49c03c87ac91a8d67bf967730fa9daba"
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
