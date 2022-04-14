class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.9.15.tar.gz"
  sha256 "3fee2d2b65bb57ff58128748b2ced35edfd2c52b7692bf696c5d28ec6c61e0c3"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51396cdb2b484398a4cf769c25b36567767420ea9ba6133d8c40d07d8404e55f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9aa0b688b8150c0f4fd1e337da21493cda48776ebb2395afe1f7033c4251f99"
    sha256 cellar: :any_skip_relocation, monterey:       "1389e0e12c6521df0f601167c400ce110d1717edfeb75dd81374ec8a5cec2121"
    sha256 cellar: :any_skip_relocation, big_sur:        "f368b6dbbdaf8f5f1c81e3498e2d010da17e6e4db7af84c54cdb0d67d2c4b10c"
    sha256 cellar: :any_skip_relocation, catalina:       "1fe7e0ed3ebdd1a8705f6e7d243f07667337e72d8a45e8129f1fa0313f7f98c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7703534216ba8b186fcc3817c96694f3c8775d2700851dd937dcc64a37d68bc5"
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
