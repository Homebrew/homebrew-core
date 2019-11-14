class SshAudit < Formula
  desc "SSH server & client auditing"
  homepage "https://github.com/jtesta/ssh-audit"
  url "https://github.com/jtesta/ssh-audit/releases/download/v2.1.0/ssh-audit-2.1.0.tar.gz"
  sha256 "0c689500b2e2d4496914b5e100705ef8289c21d7b5f0d081470ae25e5b661f63"
  head "https://github.com/jtesta/ssh-audit.git"

  bottle :unneeded

  depends_on "python"

  def install
    bin.install "ssh-audit.py" => "ssh-audit"
  end

  test do
    output = shell_output("#{bin}/ssh-audit -h 2>&1", 1)
    assert_match "force ssh version 1 only", output
  end
end
