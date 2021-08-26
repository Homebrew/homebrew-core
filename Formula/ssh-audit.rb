class SshAudit < Formula
  include Language::Python::Virtualenv

  desc "SSH server & client auditing"
  homepage "https://github.com/jtesta/ssh-audit"
  url "https://files.pythonhosted.org/packages/ae/72/44b29342575dee57470a11b92b12430b3afb63a963aa356c356b0b747522/ssh-audit-2.5.0.tar.gz"
  sha256 "3397f751bc7b9997e4236aece2d41973c766f1e44b15bc6d51a1420a14bf05b6"
  license "MIT"
  head "https://github.com/jtesta/ssh-audit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8bb5287d63d9ac17380fd712b1e263b13f88cff456685bb1f34a21812491f807"
    sha256 cellar: :any_skip_relocation, big_sur:       "68ef1fb06d02ac84edd2409a4988353684279f717dc9678411ac3a6eec37b12e"
    sha256 cellar: :any_skip_relocation, catalina:      "03faa5f6e250751b1247704617e78e7e4a27387d7c2c586a3f373576898cfc81"
    sha256 cellar: :any_skip_relocation, mojave:        "f01d8bd0cb8b9d461c8b9f93b765def198756cacbe623a8345efabf93a9984f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "926a05db7d305de243e55d97031b12c8f6f16f6249442743227ce9a89b445057"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "[exception]", shell_output("#{bin}/ssh-audit -nt 0 ssh.github.com", 1)
  end
end
