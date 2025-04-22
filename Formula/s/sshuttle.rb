class Sshuttle < Formula
  include Language::Python::Virtualenv

  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://files.pythonhosted.org/packages/0d/98/2e91205e87b2c27849a923cf3ba6602cf13d8ddabe2d8d7726b6593d4709/sshuttle-1.3.1.tar.gz"
  sha256 "04c2b16164b4b2b5945ff17c4556a8a2f0d63fb1ea2ca032748f047852ff2fcb"
  license "LGPL-2.1-or-later"
  head "https://github.com/sshuttle/sshuttle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1d18d85477c5d6d21b3cd3402f34a358ea9fb4d219712f71949e3935971ff3bf"
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
