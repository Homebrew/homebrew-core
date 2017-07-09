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
    sha256 "11492c4d73a18bf5adcce436361fcd9ff5c37d416f110d6a3c1e3ce8dc745936" => :sierra
    sha256 "d07d306b5b13f9f6c9b9d9ff6b35b73cffc2c9fe9c429ac121b5d4b3fbfa1d33" => :el_capitan
    sha256 "d03433ae8b8530a36885ffc70d1c73acb71063940afb413a1bb7287e06fbbe5c" => :yosemite
    sha256 "d70d49fa20f1bd9b4504c1476e88f46ce03f0d1efeb2086d4de547aea9eeb6e1" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

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
