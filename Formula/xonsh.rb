class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/19/f3/f23a5412cc1dbf3f7190d7674c9e1b30f1cd0ede442c63462ff80ed8484f/xonsh-0.12.2.tar.gz"
  sha256 "0876164a54f95f0bcf574236850c0880397238274cc4de31d89086f086dbeb09"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f38f8e0752b2f9f00a7a7c50242c2d7b41bdea5e4161fca59535387eaa3521fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d73dc14a1e41bcd37345bf32c714ca46e4f4c36847013dced4fdbcb2a412238"
    sha256 cellar: :any_skip_relocation, monterey:       "b01ca9dea5a23c147df3d2384a7494c6cf007f386ae988ca64bcf3fb9310bbd1"
    sha256 cellar: :any_skip_relocation, big_sur:        "4687d75210cf226dae400a886990abee18daab7828aa9303d1adfcfef539fec6"
    sha256 cellar: :any_skip_relocation, catalina:       "b840358180ff2b80c51c12dde186cb3971a371162d63703b5b015d54d72b2d6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4df6f66267d02c44b94e5eef3f18c852e92b6102a64fb26eb3fc439bf2a27b5a"
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
