class SshCopyId < Formula
  desc "Add a public key to a remote machine's authorized_keys file"
  homepage "https://www.openssh.com/"
  url "https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-8.6p1.tar.gz"
  mirror "https://mirror.vdms.io/pub/OpenBSD/OpenSSH/portable/openssh-8.6p1.tar.gz"
  version "8.6p1"
  sha256 "c3e6e4da1621762c850d03b47eed1e48dff4cc9608ddeb547202a234df8ed7ae"
  license "SSH-OpenSSH"
  head "https://github.com/openssh/openssh-portable.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0a70abbf0873a98e1f1653781006036f67a2cdf6a2d372e7de2865a50d2ba2cd"
  end

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
