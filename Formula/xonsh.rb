class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://github.com/xonsh/xonsh/archive/0.7.7.tar.gz"
  sha256 "8f63ed670439d7b065a3cb90c29ad89e3bf4a7553f4a8b7b1d0968a85a3d922e"
  head "https://github.com/xonsh/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "55c1800cfb7f4762b88c565f2aa151d153ecced6577db9a22d5ca5b549524543" => :mojave
    sha256 "30d3ffd6752f3624ce8a6daad76fb7db7d33e6187a15c421d079986f83b7d3f4" => :high_sierra
    sha256 "678dd291c1572271e91a64d3dfbd1293d5d43df658d6315d5233de57078c554c" => :sierra
    sha256 "c8665360781b8d4c3145af2376c05e57f1bbc80363d063c61f194a4aef821c68" => :el_capitan
  end

  depends_on "python"

  # Resources based on `pip3 install xonsh[ptk,pygments,proctitle]`
  # See https://xon.sh/osx.html#dependencies

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/77/bf/5d7664605c91db8f39a3e49abb57a3c933731a90b7a58cdcafd4a9bcbe97/prompt_toolkit-2.0.4.tar.gz"
    sha256 "ff58ce8bb82c11c43416dd3eec7701dcbe8c576e2d7649f1d2b9d21a2fd93808"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"
    sha256 "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/5a/0d/dc0d2234aacba6cf1a729964383e3452c52096dc695581248b548786f2b3/setproctitle-1.1.10.tar.gz"
    sha256 "6283b7a58477dd8478fbb9e76defb37968ee4ba47b05ec1c053cb39638bd7398"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/55/11/e4a2bb08bb450fdbd42cc709dd40de4ed2c472cf0ccb9e64af22279c5495/wcwidth-0.1.7.tar.gz"
    sha256 "3df37372226d6e63e1b1e1eda15c594bca98a22d33a23832a90998faa96bc65e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
