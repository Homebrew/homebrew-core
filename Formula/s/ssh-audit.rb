class SshAudit < Formula
  include Language::Python::Virtualenv

  desc "SSH server & client auditing"
  homepage "https://github.com/jtesta/ssh-audit"
  url "https://files.pythonhosted.org/packages/c8/b9/974b5dff0b2ae42fde4773f3115e02aa58efed93b70a4888888c056238f8/ssh-audit-3.1.0.tar.gz"
  sha256 "c1c0e9e7352140e4d36aea6b447210e9e0fc00314b823d3ff96352d558bef677"
  license "MIT"
  head "https://github.com/jtesta/ssh-audit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "231b26bfcae60f92fc8766bdba6d82b5013ffa669689a8f9eaf3e45604506af3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "180ea605ba8cebf35e17aa7695b1b1c41957bc16491599c77cb56e4a106317c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ff8619da250f913cbd1bbf81c6a168ab9f1780a8dbd86f977b3cd89d6ec4811"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc049ea4db56df060a6513772846526cd7443a41ab537a4b124980c2d08312f1"
    sha256 cellar: :any_skip_relocation, ventura:        "b31a34aeab839177c678750134ae1f41ec51e2a0576749108fd1336eab29402d"
    sha256 cellar: :any_skip_relocation, monterey:       "b0036a058a530f10077f15c005263e959dce4d6090dd0b10a84efcb6a32547f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a64a87ae4c903840ce4e0cd3b2f75653b38f4d51a726dd9941acfc10fab3d521"
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
