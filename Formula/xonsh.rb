class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/21/a3/6b13fe53a102edbcde11a8519cc8963afc2156ec1fdefdbc4b0f3a389a7b/xonsh-0.12.4.tar.gz"
  sha256 "a3d394db471097762ecbdedcd35686efd1aac3b5885f614501403f6d09628a76"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e07d7a467bff2031d4ec5ddd6a68ae90c9c6d072de9f2abfe42e7409208074e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a85cf7db28cece4eadabd84356cea621842964bdb50ab42ee3b7a1880d0e691e"
    sha256 cellar: :any_skip_relocation, monterey:       "38d255d5d9e5eb7484eefc85478a120a29cf23333511ad91b779775ef6d0f429"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a46d330f22ef52df665c42be640639a6ce42bc9fceef000f53f0883a27970cd"
    sha256 cellar: :any_skip_relocation, catalina:       "1ffee830f94271e6e108e3a8decfe1d7fe74a89689312012b00f9ea5b0086926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b221a4566706b8d2a10d7fb27681cfb4ff08e702a3e89a025a6d0837245e48c"
  end

  depends_on "python@3.10"

  # Resources based on `pip3 install xonsh[ptk,pygments,proctitle]`
  # See https://xon.sh/osx.html#dependencies

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/59/68/4d80f22e889ea34f20483ae3d4ca3f8d15f15264bcfb75e52b90fb5aefa5/prompt_toolkit-3.0.29.tar.gz"
    sha256 "bd640f60e8cecd74f0dc249713d433ace2ddc62b65ee07f96d358e0b152b6ea7"
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
    url "https://files.pythonhosted.org/packages/78/9a/cf6bf4c472b59aef3f3c0184233eeea8938d3366bcdd93d525261b1b9e0a/setproctitle-1.2.3.tar.gz"
    sha256 "ecf28b1c07a799d76f4326e508157b71aeda07b84b90368ea451c0710dbd32c0"
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
