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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a168c37baa642d779295f93e629544a8ce7fd617e452f640d75aa2051a9444b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a168c37baa642d779295f93e629544a8ce7fd617e452f640d75aa2051a9444b"
    sha256 cellar: :any_skip_relocation, monterey:       "a73b9cc6c22017af4ceae38c7ef0a90b275b7a77a7f1634eaa2ec2cf8180b144"
    sha256 cellar: :any_skip_relocation, big_sur:        "a73b9cc6c22017af4ceae38c7ef0a90b275b7a77a7f1634eaa2ec2cf8180b144"
    sha256 cellar: :any_skip_relocation, catalina:       "a73b9cc6c22017af4ceae38c7ef0a90b275b7a77a7f1634eaa2ec2cf8180b144"
    sha256 cellar: :any_skip_relocation, mojave:         "a73b9cc6c22017af4ceae38c7ef0a90b275b7a77a7f1634eaa2ec2cf8180b144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce635f09e402480c3646cfc10c5dde97be34db29c70c6056308b999f8077ada8"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "[exception]", shell_output("#{bin}/ssh-audit -nt 0 ssh.github.com", 1)
  end
end
