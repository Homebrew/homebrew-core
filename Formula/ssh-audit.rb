class SshAudit < Formula
  include Language::Python::Virtualenv

  desc "SSH server & client auditing"
  homepage "https://github.com/jtesta/ssh-audit"
  url "https://files.pythonhosted.org/packages/ae/72/44b29342575dee57470a11b92b12430b3afb63a963aa356c356b0b747522/ssh-audit-2.5.0.tar.gz"
  sha256 "3397f751bc7b9997e4236aece2d41973c766f1e44b15bc6d51a1420a14bf05b6"
  license "MIT"
  revision 1
  head "https://github.com/jtesta/ssh-audit.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88da564fe01d5d804574d2942814cb310731f827cc9183ff3c9266543c83b33d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88da564fe01d5d804574d2942814cb310731f827cc9183ff3c9266543c83b33d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88da564fe01d5d804574d2942814cb310731f827cc9183ff3c9266543c83b33d"
    sha256 cellar: :any_skip_relocation, ventura:        "9294b5cdcc5f45014d5d4f8289c7976037adfa7a6f4f82d713026df126c1dabf"
    sha256 cellar: :any_skip_relocation, monterey:       "9294b5cdcc5f45014d5d4f8289c7976037adfa7a6f4f82d713026df126c1dabf"
    sha256 cellar: :any_skip_relocation, big_sur:        "9294b5cdcc5f45014d5d4f8289c7976037adfa7a6f4f82d713026df126c1dabf"
    sha256 cellar: :any_skip_relocation, catalina:       "9294b5cdcc5f45014d5d4f8289c7976037adfa7a6f4f82d713026df126c1dabf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49de8dbf2d2f30886de11f3398c04ea45dccd76285b7c8b4f9afafd778ed1490"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "[exception]", shell_output("#{bin}/ssh-audit -nt 0 ssh.github.com", 1)
  end
end
