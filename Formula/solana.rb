class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.14.17.tar.gz"
  sha256 "30678dd133a82d149684e59353f1c99645d44bcc630a4ae13ac8c29461f87a32"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c226191a7be9cb2a9eeefcd3ed0c6b703acb37432273c5cac0e40cbdc4798f97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3846e41617e27cf91aa5dca8ec8ebcca359b3df18b25adce1e4ba58ee0eac3a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ad93ccc05e8863943521526b69ce9cd3a91c971cbdc71902a9be0d4a4eef8d4"
    sha256 cellar: :any_skip_relocation, ventura:        "e5d1cbd43da8d1489e1ec43e27021221c36ed8b63a0638e13373bbe4cc875dff"
    sha256 cellar: :any_skip_relocation, monterey:       "326bc1c1f96b79756453e9764907df4a71a4407cc7facd719332b13067bcb320"
    sha256 cellar: :any_skip_relocation, big_sur:        "c47ff53a5ba70224744a28259b92e49225fc70735833aabfb99a226370973cc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d13ff827c87d2f82077d649df9774ed76d6c6ced366da1d9cac45fffe8505a77"
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
      system "cargo", "install", "--no-default-features", *std_cargo_args(path: bin)
    end
  end

  test do
    assert_match "Generating a new keypair",
      shell_output("#{bin}/solana-keygen new --no-bip39-passphrase --no-outfile")
    assert_match version.to_s, shell_output("#{bin}/solana-keygen --version")
  end
end
