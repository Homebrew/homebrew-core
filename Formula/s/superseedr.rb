class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://github.com/Jagalite/superseedr/archive/refs/tags/v1.0.16.tar.gz"
  sha256 "35febb814a10a16db6fa6fa85da48ae897d54e30a45ce835a6f4e3ed43d58195"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "60e4281a0e5c1c86c96f36a427bf487e72c7a8a83d0f005d5bd3e1ad48880ac5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "33e0edafb401d6cbdfa260d429cae8cf677f9ef0e15ecd8d5f320c50313cd733"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8b2e1dd608f456866aa28f7319643f31fe80268d5554e1434dcac468be66c82f"
    sha256 cellar: :any,                 arm64_linux:       "62f18afdacffe78301f64b544982866782b54643ad2cbf8fae6a7417f844c9cd"
    sha256 cellar: :any,                 x86_64_linux:      "aa4734489ac771a55bc4f71cc42f75e25d24a3fbc233513d5e936adfb1b823b6"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # superseedr is a TUI application
    assert_match version.to_s, shell_output("#{bin}/superseedr --version")
  end
end
