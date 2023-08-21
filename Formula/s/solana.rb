class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.14.24.tar.gz"
  sha256 "1ca45518f62e4884c9b30fa5682f47d9874f8d0bb2234ca2d67ef0a9370a724f"
  license "Apache-2.0"
  version_scheme 1

  # This formula tracks the stable channel but the "latest" release on GitHub
  # varies between Mainnet and Testnet releases. This identifies versions by
  # checking the releases page and only matching Mainnet releases.
  livecheck do
    url "https://github.com/solana-labs/solana/releases?q=prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >][^>]*?>\s*Mainnet}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bf76b7363a996c6f4ec12668c98f3151f62d8dfed4855ee068ceedc1ec7256b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0378829e107c4caefbaaa6cb21c502faf0556953d48410893bebdee1dbf0888"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b018fef6442ce6a526677f8291e6ae199e7c262575aa42043970e72f728dc60f"
    sha256 cellar: :any_skip_relocation, ventura:        "280fc23e390318bc1e620c65592bfa2e0443ffb36007b2cc32519954e8cc5df1"
    sha256 cellar: :any_skip_relocation, monterey:       "d5e8a5e8ec21e1be4cbdf309da1e381971a4ac4f56d70e73b606cb9eb6828589"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f043129c654a4ca5bcaa77e459bfe873aa8bbc252aa1e79277be67dae9ebcea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f991ef664c61b0fa7ee400483ef1860468dd20668d74cdcae6f7990abda996f"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
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
      system "cargo", "install", "--no-default-features", *std_cargo_args(path: bin)
    end
  end

  test do
    assert_match "Generating a new keypair",
      shell_output("#{bin}/solana-keygen new --no-bip39-passphrase --no-outfile")
    assert_match version.to_s, shell_output("#{bin}/solana-keygen --version")
  end
end
