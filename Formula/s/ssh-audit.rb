class SshAudit < Formula
  include Language::Python::Virtualenv

  desc "SSH server & client auditing"
  homepage "https://github.com/jtesta/ssh-audit"
  url "https://files.pythonhosted.org/packages/f2/b9/88c7f0ecba0a8fbf07e0d7674b7eac3dbf5270ac39a3b48bc34bb7c5a22c/ssh-audit-3.0.0.tar.gz"
  sha256 "a6a9f94f6f718b56961b70dbf1efcc0e42b3441822e1ea7b0c043fce1f749072"
  license "MIT"
  head "https://github.com/jtesta/ssh-audit.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c883e4b2c2fa5f0694ba66916d581510479ba36b7f5e4a17b08f7846357bee5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "208f5a752a3e9776c752d661574d76ec94c0b63574e281d189486a977e1d3edc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbe512500b86bef0fd721ff16caefd41cb86f9792b28e444b8592832bfa622a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6aeb1dafaaab89a2b73986f94f3d43d2334a9374e0ebcb544756cb076b0c1b8"
    sha256 cellar: :any_skip_relocation, ventura:        "f199d3a985d55b3f52f0dbd0b74ec1959f95fef5c17b56cd0be3c045c9116249"
    sha256 cellar: :any_skip_relocation, monterey:       "7812a0804faf46c1451c5e163bc8ae45f94bf5a208016b71f5f6c78ee6d7490a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "122b8fc613a7b844dfe9f34d5a06e34de89dea54ea91ef82d73eca05b5728447"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "[exception]", shell_output("#{bin}/ssh-audit -nt 0 ssh.github.com", 1)
  end
end
