class SshAudit < Formula
  include Language::Python::Virtualenv

  desc "SSH server & client auditing"
  homepage "https://github.com/jtesta/ssh-audit"
  url "https://files.pythonhosted.org/packages/b4/95/0dc036428ef8d76e2c812cbec9e69c2020230da32ea0e699908735894a2f/ssh_audit-3.9.0.tar.gz"
  sha256 "f1225d0364b3cb61c7dfb1f5065a6958dbb814d98b2c1dd2a779ba2cdef41f61"
  license "MIT"
  head "https://github.com/jtesta/ssh-audit.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "3f1f77cd67b3375aede1430947ce9021ce8e38e0e4941777c1affcb788e8a450"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/ssh-audit -nt 0 ssh.github.com", 1)
    assert_match "[exception] cannot connect to ssh.github.com port 22", output

    assert_match "ssh-audit v#{version}", shell_output("#{bin}/ssh-audit -h")
  end
end
