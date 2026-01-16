class Sshpass < Formula
  desc "Non-interactive SSH password auth"
  homepage "https://sourceforge.net/projects/sshpass/"
  url "https://master.dl.sourceforge.net/project/sshpass/sshpass/1.10/sshpass-1.10.tar.gz"
  sha256 "ad1106c203cbb56185ca3bad8c6ccafca3b4064696194da879f81c8d7bdfeeda"
  license "GPL-2.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "963f3ed3cfe2211b809ffa9a0275c2672e375a8ffc06c1df7acf7b69141815d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "38020f688c751708ec42752d847ffb0dcaa9987a9cb362f7b20adc80a2c60b9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5971bfb9484ec0c541e8a49f444e9ab6dda42375deb472607502dd6cef5e8589"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68bdbd395f0468e15c2de3fafa5ce0ecf70b8411e8ea8f770615e7a2e9eea661"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16d33a316e38f7f4005352ea7e3a19fab9e1d29bc1da3cdb645ee490082646a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "aaae8efa23cf70f1149c669245ed78a75a0228a65bcc5457176ee6d232b0eac7"
    sha256 cellar: :any_skip_relocation, ventura:        "5f2c50426dc465a5dd28bc1901b3b4cf0b2c20d3e32c2c44870a891c165a23f4"
    sha256 cellar: :any_skip_relocation, monterey:       "c291394d903ecea28d08974c70f8692349f0a08295d09f06750911cf8d244d40"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "053be70fcc130a45fd5ac4d131ca5bab40ee4a3d543ffab73ed8f455defd486c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29700081d945fb21d977430b0fabefb7e38a53da955ffb2a9b1d28e14203c877"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  def caveats
    <<~EOS
      Sshpass is a tool for non-interactively performing password authentication
      with SSH's so called "interactive keyboard password authentication".
      Most users should use SSH's more secure public key authentication instead.

      See `man sshpass` for more information.
    EOS
  end

  test do
    output = shell_output("#{bin}/sshpass -P password ssh foo@bar ls 2>&1", 255)
    assert_match(/ssh: Could not resolve hostname bar/, output)
  end
end
