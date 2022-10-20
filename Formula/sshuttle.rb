class Sshuttle < Formula
  include Language::Python::Virtualenv

  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://files.pythonhosted.org/packages/f1/4d/91c8bff8fabe44cd88edce0b18e874e60f1e11d4e9d37c254f2671e1a3d4/sshuttle-1.1.1.tar.gz"
  sha256 "f5a3ed1e5ab1213c7a6df860af41f1a903ab2cafbfef71f371acdcff21e69ee6"
  license "LGPL-2.1-or-later"
  head "https://github.com/sshuttle/sshuttle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa3c0c2cdac816d89ea7b05edf90de1ba43e6359ce63c2fe72de2e6734b2cc37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa3c0c2cdac816d89ea7b05edf90de1ba43e6359ce63c2fe72de2e6734b2cc37"
    sha256 cellar: :any_skip_relocation, monterey:       "a5040bd0cd340a9c946caf45ea28d4e4856bc2773535624e6796d48eb4ba4252"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5040bd0cd340a9c946caf45ea28d4e4856bc2773535624e6796d48eb4ba4252"
    sha256 cellar: :any_skip_relocation, catalina:       "a5040bd0cd340a9c946caf45ea28d4e4856bc2773535624e6796d48eb4ba4252"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8086506e5b3d061c4cd7df782689a32eda5c5edeead80042049c5968ba33363"
  end

  depends_on "python@3.10"

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
