class SshAudit < Formula
  desc "SSH server & client auditing"
  homepage "https://github.com/jtesta/ssh-audit"
  url "https://github.com/jtesta/ssh-audit/releases/download/v2.1.1/ssh-audit-2.1.1.tar.gz"
  sha256 "e70d7dfb98fa4941f07424783a2f601c9e3920eb33da53997c13b9d7d2720dcb"
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
