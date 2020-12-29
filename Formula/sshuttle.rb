class Sshuttle < Formula
  include Language::Python::Virtualenv

  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://files.pythonhosted.org/packages/e9/4b/51d6aaa900a6a13efb380b0a084a327c41aad28a267d4c1f074cb2e41baa/sshuttle-1.0.5.tar.gz"
  sha256 "fd8c691aac2cb80933aae7f94d9d9e271a820efc5c48e73408f1a90da426a1bd"
  license "LGPL-2.1-or-later"
  head "https://github.com/sshuttle/sshuttle.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7f4c70a8575c778a65de46eebfe61151945b37c0d958a66fca7aa5ead3ab7c1c" => :big_sur
    sha256 "9b1b795e0817955ebc66c0a8ddfa18e41951c6cea2dea4126cd346c3afbbd5a3" => :arm64_big_sur
    sha256 "c9d9ba4721a391e1e02484003fc995fd3a11b8f2e2a803353f24e0b5ef87da78" => :catalina
    sha256 "874db8f6c57d63d054b1e24d6ad083f218cbf366d926406faa78ce4c0bcfc987" => :mojave
  end

  depends_on "python@3.9"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

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
