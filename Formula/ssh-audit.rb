class SshAudit < Formula
  include Language::Python::Shebang

  desc "SSH server & client auditing"
  homepage "https://github.com/jtesta/ssh-audit"
  url "https://github.com/jtesta/ssh-audit/releases/download/v2.3.0/ssh-audit-2.3.0.tar.gz"
  sha256 "776547591e7b69a2a8dcd1eaaac5d38321f2cb4a5de5f8e5a3e135b33236e812"
  license "MIT"
  revision 1
  head "https://github.com/jtesta/ssh-audit.git"

  bottle :unneeded

  depends_on "python@3.9"

  def install
    rewrite_shebang detected_python_shebang, "ssh-audit.py"
    bin.install "ssh-audit.py" => "ssh-audit"
  end

  test do
    assert_match "[exception]", shell_output("#{bin}/ssh-audit -nt 0 ssh.github.com", 1)
  end
end
