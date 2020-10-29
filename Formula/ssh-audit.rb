class SshAudit < Formula
  include Language::Python::Virtualenv

  desc "SSH server & client auditing"
  homepage "https://github.com/jtesta/ssh-audit"
  url "https://files.pythonhosted.org/packages/61/09/d4ec73164f4548b7352389117ed0a30e47c444a76c18046421e22311f8ea/ssh-audit-2.3.1.tar.gz"
  sha256 "84d3294b25f3a1ce0a5f14094e80d85cfded3b5ef941c0df131cf7485d449b6b"
  license "MIT"
  head "https://github.com/jtesta/ssh-audit.git"

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "[exception]", shell_output("#{bin}/ssh-audit -nt 0 ssh.github.com", 1)
  end
end
