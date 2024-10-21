class Sshuttle < Formula
  include Language::Python::Virtualenv

  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://files.pythonhosted.org/packages/94/6e/f9a1fb50cd034cac1ee4efd017a9873301f75103271205a8f1c411a9fb1e/sshuttle-1.1.2.tar.gz"
  sha256 "f1f82bc59c45745df7543f38b0fa0f1a6a34d8a9e17dd8d9e5e259f069c763d6"
  license "LGPL-2.1-or-later"
  head "https://github.com/sshuttle/sshuttle.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "65afba150043765a0b7d5e5418fd31c0830db77e71694d9ca7968617cdecab96"
  end

  depends_on "python@3.13"

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
