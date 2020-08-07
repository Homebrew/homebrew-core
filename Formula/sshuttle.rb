class Sshuttle < Formula
  include Language::Python::Virtualenv

  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://github.com/sshuttle/sshuttle.git",
      tag:      "v1.0.3",
      revision: "c5dcc918db666dfd1b30afc72cc198abfb3b3aa9"
  license "LGPL-2.0"
  head "https://github.com/sshuttle/sshuttle.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f44682243fd2b0ffd1f463f8eca6a93a0575b8b52e27d14c2bbb0d5cdee72f32" => :catalina
    sha256 "4a16f0170fc41f77af6a8994dc587cc5510de7be1b7fab4ad5968fb6d402587f" => :mojave
    sha256 "d466f1fb7d5dd3ae8f2ceec36a5d2348c124c25847db7d7156db59554c81ea44" => :high_sierra
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
