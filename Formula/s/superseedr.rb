class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://github.com/Jagalite/superseedr/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "30e8073b1a511d88923b62dac9a9120e3ca190d84a781b34799080e91706fd76"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16861ecc33a1dd858c5e49f45b7bc75ddde5ceea5b536798218b4b4ec25fc2a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6afd1221a0913685c7afa8ccaee2c4425af095a95facb971ca088931ede16230"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6ad5e760d6d1016c017a1a34697812008fb2599f961b065cf6130b1dd0f1891"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0d04803343c0391fdab5353f6e67375c6596a351a874511ee3e3ca7ce609f0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03fa3669c52a608ae1c72ba5c4e560fbd376266ddfb0e10dc410991f23158e51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c94a028e7dbdfa47076c5c14825bfe0641314d2e1280bbb05a01d45090983de6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # superseedr is a TUI application
    assert_match version.to_s, shell_output("#{bin}/superseedr --version")
  end
end
