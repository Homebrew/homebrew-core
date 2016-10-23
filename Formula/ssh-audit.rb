class SshAudit < Formula
  desc "SSH server auditing"
  homepage "https://github.com/arthepsy/ssh-audit"
  url "https://github.com/arthepsy/ssh-audit/archive/v1.6.0.tar.gz"
  sha256 "efebff6d39f270cde5e235f1e3cbaedd8a56e693c810e91dd4a48aaceb0ca2dd"

  head "https://github.com/arthepsy/ssh-audit.git"

  bottle :unneeded

  depends_on :python

  def install
    bin.install "ssh-audit.py" => "ssh-audit"
  end

  test do
    output = shell_output("#{bin}/ssh-audit -h 2>&1", 1)
    assert_match "force ssh version 1 only", output
  end
end
