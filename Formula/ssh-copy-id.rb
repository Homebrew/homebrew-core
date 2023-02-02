class SshCopyId < Formula
  desc "Add a public key to a remote machine's authorized_keys file"
  homepage "https://www.openssh.com/"
  url "https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-9.2p1.tar.gz"
  mirror "https://cloudflare.cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-9.2p1.tar.gz"
  version "9.2p1"
  sha256 "3f66dbf1655fb45f50e1c56da62ab01218c228807b21338d634ebcdf9d71cf46"
  license "SSH-OpenSSH"
  head "https://github.com/openssh/openssh-portable.git", branch: "master"

  livecheck do
    formula "openssh"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "adbfffa452595c8b3c0a4f491200f0d1ccbe95f54df180001ba3e10e7286d227"
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
