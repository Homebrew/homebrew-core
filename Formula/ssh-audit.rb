class SshAudit < Formula
  desc "SSH server auditing"
  homepage "https://github.com/jtesta/ssh-audit"
  url "https://github.com/jtesta/ssh-audit/releases/download/v2.0.0/ssh-audit-v2.0.0.tar.gz"
  sha256 "9ae7db82c343fc2d3af20994e750fbe69da8bed7ecde14e3fd8607d23b758c75"
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
