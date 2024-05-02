class SshAudit < Formula
  include Language::Python::Virtualenv

  desc "SSH server & client auditing"
  homepage "https://github.com/jtesta/ssh-audit"
  url "https://files.pythonhosted.org/packages/f1/26/5b724f1ade0a40aeea41cf39e7db497209a97b947b48acf378bf7630fa87/ssh_audit-3.2.0.tar.gz"
  sha256 "ebbad6b5e9e0ad930e8d2d7034f890605a461ad52bf7021a09fd9edf17945e31"
  license "MIT"
  head "https://github.com/jtesta/ssh-audit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e52d6192b5ca6851ead47cd60f94820beaf7e8daa570100fb29cfa434bea2764"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e52d6192b5ca6851ead47cd60f94820beaf7e8daa570100fb29cfa434bea2764"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e52d6192b5ca6851ead47cd60f94820beaf7e8daa570100fb29cfa434bea2764"
    sha256 cellar: :any_skip_relocation, sonoma:         "e52d6192b5ca6851ead47cd60f94820beaf7e8daa570100fb29cfa434bea2764"
    sha256 cellar: :any_skip_relocation, ventura:        "e52d6192b5ca6851ead47cd60f94820beaf7e8daa570100fb29cfa434bea2764"
    sha256 cellar: :any_skip_relocation, monterey:       "e52d6192b5ca6851ead47cd60f94820beaf7e8daa570100fb29cfa434bea2764"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50405aed6aa6e102ad1bce2902670ff28b47b9c02d2c9adcff3c0497fbd11271"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/ssh-audit -nt 0 ssh.github.com", 1)
    assert_match "[exception] cannot connect to ssh.github.com port 22", output

    assert_match "ssh-audit v#{version}", shell_output("#{bin}/ssh-audit -h")
  end
end
