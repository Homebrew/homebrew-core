class Sshuttle < Formula
  include Language::Python::Virtualenv

  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://github.com/sshuttle/sshuttle.git",
      :tag => "v0.78.3",
      :revision => "b65bb290230b0f78fe0bb46f215c16076392b28e"
  head "https://github.com/sshuttle/sshuttle.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "02ff84aff45b968c2685ad2429ba1a5820f0930ee77ddf28f9a7e9b36311380c" => :high_sierra
    sha256 "677db6306476590182ebf739924cb057fcb41847e2668aca31af32c8b3e3dbf6" => :sierra
    sha256 "287a7cd5066f88d3157563ee5554fbaaee253f1411eaf7c7a35739e9e9a9b43e" => :el_capitan
    sha256 "a9fde5286721fe460cebc1bbb03262298e443b7df923fc38a8e1bd40e7d2bed9" => :yosemite
  end

  depends_on "python" if MacOS.version <= :snow_leopard

  def install
    # Building the docs requires installing
    # markdown & BeautifulSoup Python modules
    # so we don't.
    virtualenv_install_with_resources
  end

  test do
    system bin/"sshuttle", "-h"
  end
end
