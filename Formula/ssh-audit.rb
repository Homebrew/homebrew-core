class SshAudit < Formula
  include Language::Python::Virtualenv

  desc "SSH server & client auditing"
  homepage "https://github.com/jtesta/ssh-audit"
  url "https://files.pythonhosted.org/packages/ae/72/44b29342575dee57470a11b92b12430b3afb63a963aa356c356b0b747522/ssh-audit-2.5.0.tar.gz"
  sha256 "3397f751bc7b9997e4236aece2d41973c766f1e44b15bc6d51a1420a14bf05b6"
  license "MIT"
  head "https://github.com/jtesta/ssh-audit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5aa1b2e66cbfe400cefe9cec235accee9e70cf66f9816dffbca2ae483c4c40d4"
    sha256 cellar: :any_skip_relocation, big_sur:       "4470233747b0de7046aad58f217f918b7020b3aa1b965bb572b0d5a72aadd35c"
    sha256 cellar: :any_skip_relocation, catalina:      "4470233747b0de7046aad58f217f918b7020b3aa1b965bb572b0d5a72aadd35c"
    sha256 cellar: :any_skip_relocation, mojave:        "4470233747b0de7046aad58f217f918b7020b3aa1b965bb572b0d5a72aadd35c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f6daec517b07e1a575ea7ae6f77f4f2ca6d5b50ae10b8013166682db38a514c"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "[exception]", shell_output("#{bin}/ssh-audit -nt 0 ssh.github.com", 1)
  end
end
