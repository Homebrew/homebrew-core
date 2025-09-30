class Z80dasm < Formula
  desc "Disassembler for the Zilog Z80 microprocessor and compatibles"
  # use debian site for now, cannot use debian mirror as it is still with 1.1.6
  homepage "https://packages.debian.org/sid/z80dasm"
  url "https://www.tablix.org/~avian/z80dasm/z80dasm-1.2.0.tar.gz"
  mirror "https://geeklan.co.uk/files/z80dasm-1.2.0.tar.gz"
  sha256 "8da2c4a58a3917a8229dec0da97e718f90ede84985424d74456575bf5acfeec8"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://geeklan.co.uk/files/"
    regex(/href=.*?z80dasm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "04a71156a5cbb4a8ea20743f25864bb447004f6aabfda1ef23cafede9a5d36ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "49cc209ae7b34afcfe58fd310bdcb228f6d35cadeee692049a61202bed11176f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a83c07ded5a4004a80cd9fbd9554f2a4395412279c43f50bc8482060c978a6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7c9cd6783586e4b42b3e23a608fa20e232a70ae2d5754bad8bf317a2f125359"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33d28a1075ff42df7f06221f652dea247c1da6c94eeae6df9169160b3bcfc0a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "607c7d0bbff5d35b8ddeb6cabaf4a13a3983582409c52cabe875caa29031d8cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "79f08c8c5e2fd4fcb863fd7717ba083c5e59ef3e63b0009dd7fbd54a782cd93e"
    sha256 cellar: :any_skip_relocation, ventura:        "f47879873a19e8c08153ae4981bf3b80073a46b0cb898f21207d764434c6a649"
    sha256 cellar: :any_skip_relocation, monterey:       "3593f87e2f01e8754f88014b5cdbe2875deea710b547390f69edf0412fbe6014"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6a79ae13c2cbebebc1d511dc11707c466fbab7737483d2665433c6e4484802d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f804e92b96102101c261303a335651172b29e3ee2fd033b0524e2aec3ca1b27b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3974fe69ab6b1bfddf25cdad7ff5e7c462b8df8c6605ef528a067aa5cffbb3ec"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"a.bin"
    path.binwrite [0xcd, 0x34, 0x12].pack("c*")
    assert_match "call 01234h", shell_output("#{bin}/z80dasm #{path}")
  end
end
