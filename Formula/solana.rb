class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.10.38.tar.gz"
  sha256 "276a5a7e12208770954e9bfa86339f49943767e9ad869fe6dd20bd7a4dfc4ea4"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbe3f75e8dab614b7b267027696ea9b58b8d561fc584e1aa265a06d1b8455dc5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5fd344367e55dfa84e3970b97a694a521dc0723d86adc7e76f28386f34f8b0d"
    sha256 cellar: :any_skip_relocation, monterey:       "7b0feb0be238a1e2d3baf4d64c7bf64cb42b9f0ae0eeda6d545925ea466ff341"
    sha256 cellar: :any_skip_relocation, big_sur:        "a59c8b231121bcbdc678d3f9c40b1122e15f8e3f84aa0110c2a28c04f122952a"
    sha256 cellar: :any_skip_relocation, catalina:       "f481be4c5e0a43426ea4a25e9d222c78658fae751f9ea8d614e0f1ea0d2bbf88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d29cf1a9f57b2bf5c0e2b18dfa6885706057c8abfdab97d87166716722fa9a75"
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
