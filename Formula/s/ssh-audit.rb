class SshAudit < Formula
  include Language::Python::Virtualenv

  desc "SSH server & client auditing"
  homepage "https://github.com/jtesta/ssh-audit"
  url "https://files.pythonhosted.org/packages/f1/26/5b724f1ade0a40aeea41cf39e7db497209a97b947b48acf378bf7630fa87/ssh_audit-3.2.0.tar.gz"
  sha256 "ebbad6b5e9e0ad930e8d2d7034f890605a461ad52bf7021a09fd9edf17945e31"
  license "MIT"
  head "https://github.com/jtesta/ssh-audit.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "a4f3117d4b6497b359028e5b3365a9552d0255d79feb30328ceeb0e54dda340d"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/ssh-audit -nt 0 ssh.github.com", 1)
    assert_match "[exception] cannot connect to ssh.github.com port 22", output

    assert_match "ssh-audit v#{version}", shell_output("#{bin}/ssh-audit -h")
  end
end
