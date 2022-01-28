class Sshuttle < Formula
  include Language::Python::Virtualenv

  desc "Proxy server that works as a poor man's VPN"
  homepage "https://github.com/sshuttle/sshuttle"
  url "https://files.pythonhosted.org/packages/c5/a1/6691395e9b3ad453947fea7192744f316ba3d020d295370db55ba0b48573/sshuttle-1.1.0.tar.gz"
  sha256 "21fb91bdf392b50e78db6b8d75e95b73ac9dafd361e2657e784e674561219315"
  license "LGPL-2.1-or-later"
  head "https://github.com/sshuttle/sshuttle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b299c6218a70d6f0113d6b6d75657151300a972df475ba0fcfd1226f87dfd9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b299c6218a70d6f0113d6b6d75657151300a972df475ba0fcfd1226f87dfd9f"
    sha256 cellar: :any_skip_relocation, monterey:       "3fe6a89f52a734870e0969f6851220ee507939a71d14de5606d2894006630139"
    sha256 cellar: :any_skip_relocation, big_sur:        "3fe6a89f52a734870e0969f6851220ee507939a71d14de5606d2894006630139"
    sha256 cellar: :any_skip_relocation, catalina:       "3fe6a89f52a734870e0969f6851220ee507939a71d14de5606d2894006630139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55882097e3b4b8337d1b16a908504e6ee935587c31833fecd6d5a0d18f8de2e2"
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
