class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.9.28.tar.gz"
  sha256 "07c08f990e0f38b669ad450df1629b2ce7abc53dca2787965ddc6daa43c392ff"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3e986e9f375296eed589690f98da5e401f1840add400c110079f791a2619baf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2787b2482c82e0dee62a55758d0370929980b44d708945aa16f10b2292c376fa"
    sha256 cellar: :any_skip_relocation, monterey:       "3435c111fb3fca45b117ed9c3ad1e059dc8b51bfc60560c1e7e459fcafef5ab9"
    sha256 cellar: :any_skip_relocation, big_sur:        "62cc85df13f32fca30a051ee4aa62b2d05717ec82777fc463806410af26f2427"
    sha256 cellar: :any_skip_relocation, catalina:       "9883917605b33e6362d812030e21ee49e970099a6692bf9a557810e0d51aaa9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dc3a7e2b00ea14feaae349441980f0fc16852dd2e4f948669440c2ed0be9e7d"
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
