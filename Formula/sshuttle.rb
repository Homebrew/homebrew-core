class Sshuttle < Formula
  include Language::Python::Virtualenv

  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://github.com/sshuttle/sshuttle.git",
      :tag      => "v0.78.5",
      :revision => "752a95310198886515577463a4a7e36d7f218018"
  revision 2
  head "https://github.com/sshuttle/sshuttle.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a28c54b3fa4e1c98b4d94e04366841e031e55a85ee0f161cdea37e17dd145830" => :catalina
    sha256 "ca553c22200e1c4a502750d2d50efcfbd689546ae2abca5fc80653bc9916d103" => :mojave
    sha256 "ca1764f22635b38fa2b66a3aae9677c42ce896d0b58a88be82c2f24e4b1ef592" => :high_sierra
  end

  depends_on "python@3.8"

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
