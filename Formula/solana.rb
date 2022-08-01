class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.10.32.tar.gz"
  sha256 "a6dbb7f4bc32ad984411378947caceca4e2459032d38f6ef46f468a39626a6b1"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bc52511671c18d4bbb30eb8be896795af3fd3af68962cfe7e770dd2b28750fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d79564786445f83fb027a384e80999d6017fff3f69b2cd4a7e679ebabf18e4da"
    sha256 cellar: :any_skip_relocation, monterey:       "abae0c95d0ddd01e9646c88f6673659d53de68ba87b40b7695410d5c0298dfcd"
    sha256 cellar: :any_skip_relocation, big_sur:        "44c149df14b76a16f68566b0db37f2e0ad6dfe6868333b58dd70c0e9db19455e"
    sha256 cellar: :any_skip_relocation, catalina:       "cbb2dd8ee8d2d7c1470723a0b17ea6041545ceb7675550544ded930cbfef632b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "436849b6d09799a59eebc39b5b905e8123fe681a6f0ef6db6d73f34914b97092"
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
