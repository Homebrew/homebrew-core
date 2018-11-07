class Sshuttle < Formula
  include Language::Python::Virtualenv

  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://github.com/sshuttle/sshuttle.git",
      :tag      => "v0.78.4",
      :revision => "6ec42adbf4fc7ed28e5f3c0a813779e61fa01b0f"
  revision 1
  head "https://github.com/sshuttle/sshuttle.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c076e8f57d9ec1bff5814835243d76ddb065a551855c8f6ad3e8fc9ff627957c" => :mojave
    sha256 "58b435fe5d56471fe3fa40b372c7e56f95487326b44231ccc0eb4793410a0e3d" => :high_sierra
    sha256 "6ce2edfe00756c60f3bfeaadff07ac1022fa15eab2ecfca60b41e4d4def4e937" => :sierra
  end

  depends_on "python"

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
