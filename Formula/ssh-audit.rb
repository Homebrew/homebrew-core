class SshAudit < Formula
  desc "SSH server auditing"
  homepage "https://github.com/arthepsy/ssh-audit"
  url "https://github.com/arthepsy/ssh-audit/archive/v1.7.0.tar.gz"
  sha256 "cba29cc19ec2932e4f43c720b2c49a7d179219e23482476aeb472f7463713b68"
  revision 1
  head "https://github.com/arthepsy/ssh-audit.git"

  bottle :unneeded

  depends_on "python" if MacOS.version <= :snow_leopard

  def install
    bin.install "ssh-audit.py" => "ssh-audit"
  end

  test do
    output = shell_output("#{bin}/ssh-audit -h 2>&1", 1)
    assert_match "force ssh version 1 only", output
  end
end
