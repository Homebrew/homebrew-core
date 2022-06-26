class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/b6/d1/61f3d411d8a7ac5307ce67a6a05444719492ad076c99fc5bcecf91f78abc/xonsh-0.12.6.tar.gz"
  sha256 "bd5f40c075860ccdcd0bf19a10d96c9cb89e9dd2367ef2f558366f8b24f7c61b"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d580d3c790a29a63b7a9b501289311ede71f46ba3cdfea0342172c20d9fe8e9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "086bc8d1b484e959f12a9b1a5759d370006574e4e6741fd80024a86089ab506b"
    sha256 cellar: :any_skip_relocation, monterey:       "b8b7cb4f9a8108b96c121763ea7ab43c5964d68f7ecc138aa24f2a46fb4a6889"
    sha256 cellar: :any_skip_relocation, big_sur:        "5dffb8c79a536aab413925a7378bba7a5a05534c1bcc1a9bffa93f38a9d8a4c7"
    sha256 cellar: :any_skip_relocation, catalina:       "7165942a4d969dc8d1b5f6c9ea56cfc378300e1dda443fcf65ad67c757f06cee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09bea10c29319eed50dc067b65977ae34ce5f1b306a9d897ba0036aba276b684"
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
