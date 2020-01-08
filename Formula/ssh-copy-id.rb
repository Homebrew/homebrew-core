class SshCopyId < Formula
  desc "Add a public key to a remote machine's authorized_keys file"
  homepage "https://www.openssh.com/"
  url "https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-8.1p1.tar.gz"
  mirror "https://mirror.vdms.io/pub/OpenBSD/OpenSSH/portable/openssh-8.1p1.tar.gz"
  version "8.1p1"
  sha256 "02f5dbef3835d0753556f973cd57b4c19b6b1f6cd24c03445e23ac77ca1b93ff"
  head "https://github.com/openssh/openssh-portable.git"

  bottle :unneeded

  def install
    bin.install "contrib/ssh-copy-id"
    man1.install "contrib/ssh-copy-id.1"
  end

  test do
    output = shell_output("#{bin}/ssh-copy-id -h 2>&1", 1)
    assert_match "identity_file", output
  end
end
