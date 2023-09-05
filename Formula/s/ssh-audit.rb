class SshAudit < Formula
  include Language::Python::Virtualenv

  desc "SSH server & client auditing"
  homepage "https://github.com/jtesta/ssh-audit"
  url "https://files.pythonhosted.org/packages/09/71/aa82438fa0660fc0bc63fd84bcc4be8c3f7456752ce31d4fd1221bd63b4c/ssh-audit-2.9.0.tar.gz"
  sha256 "7e68baaaa1fa42b68bcf5eefc81eb02805631e421bd84b6ae639d0cb86eb893d"
  license "MIT"
  head "https://github.com/jtesta/ssh-audit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52cdbe85ff2ae19e72029ac6751cd5553f96ea158f1fee1f9f1f76659aef3e91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52cdbe85ff2ae19e72029ac6751cd5553f96ea158f1fee1f9f1f76659aef3e91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52cdbe85ff2ae19e72029ac6751cd5553f96ea158f1fee1f9f1f76659aef3e91"
    sha256 cellar: :any_skip_relocation, ventura:        "0a10628210e4b2003ae24c7ecac43bbfbedcbc9f99ec51d5ce23fa54a140da27"
    sha256 cellar: :any_skip_relocation, monterey:       "0a10628210e4b2003ae24c7ecac43bbfbedcbc9f99ec51d5ce23fa54a140da27"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a10628210e4b2003ae24c7ecac43bbfbedcbc9f99ec51d5ce23fa54a140da27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62e991c6ee5e1bf92d4e687acaf9d27b941386bc4cb9466db881fc44b45eca4e"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "[exception]", shell_output("#{bin}/ssh-audit -nt 0 ssh.github.com", 1)
  end
end
