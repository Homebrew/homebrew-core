class Sshuttle < Formula
  include Language::Python::Virtualenv

  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://files.pythonhosted.org/packages/48/be/c1c9ead0c38383c4b2a192de4679f09413ddc6701988ca56bd220c64ec50/sshuttle-0.78.1.tar.gz"
  sha256 "03a71648ce476de06a075bd9a972492d494b414ae51304bf535b80ff22be2d3c"
  head "https://github.com/sshuttle/sshuttle.git"

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
