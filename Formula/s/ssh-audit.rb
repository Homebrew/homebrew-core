class SshAudit < Formula
  include Language::Python::Virtualenv

  desc "SSH server & client auditing"
  homepage "https://github.com/jtesta/ssh-audit"
  url "https://files.pythonhosted.org/packages/3b/ec/e89fdfaaa6f08813e1a5cf926bc0dc155761144ebcac57191b4c8001aae3/ssh_audit-3.3.0.tar.gz"
  sha256 "b76e36ac9844f45d64986c9f293a4b46766a10412dc29fb43bd52d0f6661a5b0"
  license "MIT"
  head "https://github.com/jtesta/ssh-audit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a2e7fb5fb4eb20ac00402d3920f4a37a624da249adf432d38ecc9f9158274872"
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
