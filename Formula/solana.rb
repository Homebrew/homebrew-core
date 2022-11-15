class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.13.5.tar.gz"
  sha256 "62db6f48488413cf727c1f2525dc1e56b817c4365f40d75773ca4760f7eb71f9"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8133a96ff7a631aad22fe23edf0ce7d76146a0a4b468195af9caccf58858878b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4720de58b24cbe1c65e26a254df489cafe52e726a52f9fd384f6e8d49e908127"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "908ef570e2bbb821fd5aca19c9e8a54e91f64e43f0e0a37875c34145f9851ef9"
    sha256 cellar: :any_skip_relocation, monterey:       "081c6bbb0b0e1ccebf030b8fcea80e5668bcc942e2e6fc3ee4706e3f534174d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ee3275b75a9042b850a01725c161ab54bbea6f30b412cb6e66dfaa4d80b8d2a"
    sha256 cellar: :any_skip_relocation, catalina:       "a6508f3821450a84e335b5561ef6bfb3501ef27ce61f59beab7c603bb5044b97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e6aee80972f7cf3c0ec62b8f2252986760215340a062b25c92fee8633f98a07"
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
