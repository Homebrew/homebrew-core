class SshAudit < Formula
  include Language::Python::Virtualenv

  desc "SSH server & client auditing"
  homepage "https://github.com/jtesta/ssh-audit"
  url "https://files.pythonhosted.org/packages/61/09/d4ec73164f4548b7352389117ed0a30e47c444a76c18046421e22311f8ea/ssh-audit-2.3.1.tar.gz"
  sha256 "84d3294b25f3a1ce0a5f14094e80d85cfded3b5ef941c0df131cf7485d449b6b"
  license "MIT"
  head "https://github.com/jtesta/ssh-audit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb21c8795f1ff8146e521bf89085122d1c26fcd8231f146f520f6f3c11d81726" => :big_sur
    sha256 "a35fc72d11c262a49aac55ac6b7a9697477dac8c605ea823d6c2e129bfe1e882" => :arm64_big_sur
    sha256 "6898d35256e2463dc6710f06133a29c07ca9f77b3e13f01671ce9e7a98a95278" => :catalina
    sha256 "227e07ecf11af9dc5a1b4a1a7017c390a3caa5183327e73dba8a2607c648a01d" => :mojave
    sha256 "cb1337c15074044b1dd7aa3a7026c7226bab0469dcee1ec0ed4eb960bc50dd4a" => :high_sierra
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "[exception]", shell_output("#{bin}/ssh-audit -nt 0 ssh.github.com", 1)
  end
end
