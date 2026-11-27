class Usbtree < Formula
  desc "Live USB device tree in your terminal"
  homepage "https://gnomeria.github.io/usbtree/"
  url "https://github.com/gnomeria/usbtree/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "dbff9b0c186dd973fad69fd952ea7644fed402f66d4ee1844b78d7bda29b4f23"
  license "MIT"
  head "https://github.com/gnomeria/usbtree.git", branch: "main"

  bottle do
    manifest_sha256 "b880bd71ceaac35d115f93c1af9ae30bf9aa931f277e109bff9e3d108050ea95"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "321b6c5304da843cd0df48866572145bbc0bf3605f231d8f7c97b134888b692f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "82e4a5c16b51519754e2462e53421889b41e6b6287fe853fb2c8c28f378c1c8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7dbc6c15acaec2741f0384fdd8f9e7d26b59d56b511fb2d48aec696e7d69f522"
    sha256 cellar: :any,                 arm64_linux:       "539ac4448ca031e673795492609bd372ded369a73841ac0abadf173fe91a1818"
    sha256 cellar: :any,                 x86_64_linux:      "513304aa46552da5005043c8cfb957d26310efc3420275c7d2d8eac845995925"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "controller", shell_output("#{bin}/usbtree --pci")
  end
end
