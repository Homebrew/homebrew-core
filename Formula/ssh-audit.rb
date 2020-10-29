class SshAudit < Formula
  include Language::Python::Shebang

  desc "SSH server & client auditing"
  homepage "https://github.com/jtesta/ssh-audit"
  url "https://github.com/jtesta/ssh-audit/releases/download/v2.3.1/ssh-audit-2.3.1.tar.gz"
  sha256 "3d81c2620f53e7e0fe359e94524f28b58d53aa4e77292e2c9c555e174993d314"
  license "MIT"
  head "https://github.com/jtesta/ssh-audit.git"

  bottle :unneeded

  depends_on "python@3.9"

  def install
    rewrite_shebang detected_python_shebang, "ssh-audit.py"
    bin.install "ssh-audit.py" => "ssh-audit"
    man1.install "ssh-audit.1"
  end

  test do
    assert_match "[exception]", shell_output("#{bin}/ssh-audit -nt 0 ssh.github.com", 1)
  end
end
