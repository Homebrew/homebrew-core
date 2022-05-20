class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.9.22.tar.gz"
  sha256 "63a7d1918084bba48eeb9387b185ab551fc2c3c42b8c7eca3b0f389655b44ddb"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f8c2f3661fcd18a05cae17a90ef21dd6a313a4ed2bedbf5783101bc6dc035ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d60d0a5dc28602ae4f7d07ef4f6575a257573a2634fc574cb685d1efd7c6f2b0"
    sha256 cellar: :any_skip_relocation, monterey:       "3edea1dad3a8eeb4108cb19d556b2e49ba2bb1976863598b395a5c62ac74fcc8"
    sha256 cellar: :any_skip_relocation, big_sur:        "cea4960cff9d79552a4a6ccf312e74f7ceeb0a50969bd4ca70fa5f391b2a0fa0"
    sha256 cellar: :any_skip_relocation, catalina:       "f15342b5a13f2974ddf431d13a3062a881b154d69f9de84521da3d80f4c76877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "171a8bbb5e30f0f1f69910edd60b5f963dfcd622291f1ecd47b3bd716092ed4c"
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
      cd bin do
        system "cargo", "install", "--no-default-features", *std_cargo_args
      end
    end
  end

  test do
    assert_match "Generating a new keypair",
      shell_output("#{bin}/solana-keygen new --no-bip39-passphrase --no-outfile")
    assert_match version.to_s, shell_output("#{bin}/solana-keygen --version")
  end
end
