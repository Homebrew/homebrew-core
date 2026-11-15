class Sshuttle < Formula
  include Language::Python::Virtualenv

  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://files.pythonhosted.org/packages/0b/80/a656e8958cd35102aeaa2e5c4edf6d781d806df58650fa4368c8102df47d/sshuttle-2.0.0.tar.gz"
  sha256 "7347ff01093d471c4e9a299b9c7abd4a18eac4fddfd4cf868bedc623cab71091"
  license "LGPL-2.1-or-later"
  head "https://github.com/sshuttle/sshuttle.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "754e347912971329e0e10ce367fa5540294599bf16484b18c4fb3e1bd598c9b6"
  end

  depends_on "python@3.15"

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
