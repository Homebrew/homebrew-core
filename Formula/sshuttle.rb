class Sshuttle < Formula
  include Language::Python::Virtualenv

  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://github.com/sshuttle/sshuttle.git",
      tag:      "v1.0.4",
      revision: "abb48f199656f776be0f05601ff5746f36df3370"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/sshuttle/sshuttle.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a06b10df1dfc84196e2e02b32439f1e2558ef8355192ef5afc3cbfd951eb3607" => :catalina
    sha256 "7e36de2ff8ac37e23c9d54ddd393881bd7a312163a98311b23dc70d0b9bb1f7d" => :mojave
    sha256 "323c8b112631584ca559e5a588d7822b61af3d3e8eda30a3b0699710d627af0a" => :high_sierra
  end

  depends_on "python@3.9"

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
