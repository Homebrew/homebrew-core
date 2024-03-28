class SshAudit < Formula
  include Language::Python::Virtualenv

  desc "SSH server & client auditing"
  homepage "https://github.com/jtesta/ssh-audit"
  url "https://files.pythonhosted.org/packages/c8/b9/974b5dff0b2ae42fde4773f3115e02aa58efed93b70a4888888c056238f8/ssh-audit-3.1.0.tar.gz"
  sha256 "c1c0e9e7352140e4d36aea6b447210e9e0fc00314b823d3ff96352d558bef677"
  license "MIT"
  head "https://github.com/jtesta/ssh-audit.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a619cb1938808b9f8287a0c6a06bb034731e636d4202840327ab21e891ce13f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2a0584a0b1ed329429ded79816b8b6492eb11fd38881d7636f9f4b13a7b6346"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26d24f6071a846e1da5add64d256d4aa5b89c11b929a39cbf9435dee271dc425"
    sha256 cellar: :any_skip_relocation, sonoma:         "758b38d1c6c3d27bb11495b9d056d6054637ae2cceb7e1fbcc941e1fd238e1a9"
    sha256 cellar: :any_skip_relocation, ventura:        "3b90b39d7d581ef474943fe79f902228f2b2af567e65fb7938a57afd85163d9a"
    sha256 cellar: :any_skip_relocation, monterey:       "97a49136ac35cd9f2dc88354223437bf22e3ffe35a4366f226a6585b82c91a63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2986f208ca79dad832abdfdc430e808c23e0507ea443c18711f2bfd3be148bbb"
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
