class SshAudit < Formula
  include Language::Python::Shebang

  desc "SSH server & client auditing"
  homepage "https://github.com/jtesta/ssh-audit"
  url "https://github.com/jtesta/ssh-audit/releases/download/v2.2.0/ssh-audit-2.2.0.tar.gz"
  sha256 "a8f4f01122234bd84c01440bfd3b7a6026c50c1a06f3044846a8503c94f94cfb"
  revision 1
  head "https://github.com/jtesta/ssh-audit.git"

  bottle :unneeded

  depends_on "python@3.8"

  def install
    rewrite_shebang detected_python_shebang, "ssh-audit.py"
    bin.install "ssh-audit.py" => "ssh-audit"
  end

  test do
    output = shell_output("#{bin}/ssh-audit -h 2>&1", 1)
    assert_match "force ssh version 1 only", output
  end
end
