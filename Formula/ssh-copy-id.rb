class SshCopyId < Formula
  desc "Add a public key to a remote machine's authorized_keys file"
  homepage "https://www.openssh.com/"
  url "https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-8.3p1.tar.gz"
  mirror "https://mirror.vdms.io/pub/OpenBSD/OpenSSH/portable/openssh-8.3p1.tar.gz"
  version "8.3p1"
  sha256 "f2befbe0472fe7eb75d23340eb17531cb6b3aac24075e2066b41f814e12387b2"
  license "SSH-OpenSSH"
  head "https://github.com/openssh/openssh-portable.git"

  bottle :unneeded

  keg_only :provided_by_macos

  def install
    bin.install "contrib/ssh-copy-id"
    man1.install "contrib/ssh-copy-id.1"
  end

  test do
    output = shell_output("#{bin}/ssh-copy-id -h 2>&1", 1)
    assert_match "identity_file", output
  end
end
