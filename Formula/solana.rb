class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.13.0.tar.gz"
  sha256 "ce2c7ae830bbf79bce81d2267a7267651a58d3a4dade0269533bf023ecd7c578"
  license "Apache-2.0"

  # This formula tracks the stable channel but the "latest" release on GitHub
  # varies between Mainnet and Testnet releases. This identifies versions by
  # checking the releases page and only matching Mainnet releases.
  livecheck do
    url "https://github.com/solana-labs/solana/releases?q=prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >][^>]*?>[^<]*?Mainnet}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21d46ccd45d60bad220001214d41349c64a0e5a6f0268618c9e764d3b75dbc72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "571f32e29eaeec758f1b62df5a1d055fad74504a229589cdeee7bb9ead8cc60b"
    sha256 cellar: :any_skip_relocation, monterey:       "5b5ba842d3dd26516bfc80ce3dd88ab49c14aad6e0cba01d4450c831e7cf2039"
    sha256 cellar: :any_skip_relocation, big_sur:        "3516e0474b47a61e795685f84445f825bac1be5f5c02f81c71daa1f722774beb"
    sha256 cellar: :any_skip_relocation, catalina:       "192425c166b62bf93e3b8f21915f88cfe87ee52fbdb2771e97b1ba3e5a481eba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abb501d2c680e5a268b44c75c7187198a17161d94c6ed8df57d642de3df87630"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
    depends_on "systemd"
  end

  def install
    # Fix for error: cannot find derive macro `Deserialize` in this scope. Already fixed on 1.11.x.
    # Can remove if backported to 1.10.x or when 1.11.x has a stable release.
    # Ref: https://github.com/solana-labs/solana/commit/12e24a90a009d7b8ab1ed5bb5bd42e36a4927deb
    inreplace "net-shaper/Cargo.toml", /^serde = ("[\d.]+")$/, "serde = { version = \\1, features = [\"derive\"] }"

    %w[
      cli
      bench-streamer
      faucet
      keygen
      log-analyzer
      net-shaper
      stake-accounts
      sys-tuner
      tokens
      watchtower
    ].each do |bin|
      system "cargo", "install", "--no-default-features", *std_cargo_args(path: bin)
    end
  end

  test do
    assert_match "Generating a new keypair",
      shell_output("#{bin}/solana-keygen new --no-bip39-passphrase --no-outfile")
    assert_match version.to_s, shell_output("#{bin}/solana-keygen --version")
  end
end
