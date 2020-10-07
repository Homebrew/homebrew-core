class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://github.com/xonsh/xonsh/archive/0.9.21.tar.gz"
  sha256 "b6f6a0fc8b388480bbf7aa1900dc97edf63d100a7dd572be8e5031b754e1c9f5"
  license "BSD-2-Clause-Views"
  revision 1
  head "https://github.com/xonsh/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e884ff7820dd096c93640599d0d77ea43445d5b4da76601cf87ccbd1ac1c49d" => :catalina
    sha256 "1a30ad503ef95cd9ad2bd6c4eb2e6107b3d862d6702ddc89f0894f5f027d5b37" => :mojave
    sha256 "d8f3d21965fcea70899c89399c6831de20e404f2fa89b4ff03d9a3b3caa6c139" => :high_sierra
  end

  depends_on "python@3.9"

  # Resources based on `pip3 install xonsh[ptk,pygments,proctitle]`
  # See https://xon.sh/osx.html#dependencies

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/c4/c6/03da4efaf73f0cb5a34957fdac12046eb8d8e81618bad6f60464215b829a/prompt_toolkit-3.0.6.tar.gz"
    sha256 "7630ab85a23302839a0f26b31cc24f518e6155dea1ed395ea61b42c45941b6a6"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/6e/4d/4d2fe93a35dfba417311a4ff627489a947b01dc0cc377a3673c00cf7e4b2/Pygments-2.6.1.tar.gz"
    sha256 "647344a061c249a3b74e230c739f434d7ea4d8b1d5f3721bc0f3558049b38f44"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/5a/0d/dc0d2234aacba6cf1a729964383e3452c52096dc695581248b548786f2b3/setproctitle-1.1.10.tar.gz"
    sha256 "6283b7a58477dd8478fbb9e76defb37968ee4ba47b05ec1c053cb39638bd7398"
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
