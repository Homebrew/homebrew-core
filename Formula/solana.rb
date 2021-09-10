class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/refs/tags/v1.7.11.tar.gz"
  sha256 "ed70aaed16910eab637eff0499c6e4762350c4ad50340fcb1b4bf94d23f1f97a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6468ec8ebdd518b43470073a843b8915a11bd707da9c8814056f09078a3890e5"
    sha256 cellar: :any_skip_relocation, big_sur:       "6254f037bc60fd0a9e96ce5cea6a44882ad01659ce6981c59fde1896835b1b55"
    sha256 cellar: :any_skip_relocation, catalina:      "f4a2fbd01d2263c6c1f7972f7a4b178105d83f1c64523df12dad991c187220a1"
    sha256 cellar: :any_skip_relocation, mojave:        "ad31f493248106a5da4208ff7846888c75ea1bfe4a97ffaaf24c65800cb6d62f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1322a9d0bbfa219c781d670b6069ad4f27b31cbb66baaf60420c96bdbdf1e7f"
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
    assert_match(/pubkey: \w{44}/, shell_output("#{bin}/solana-keygen new --no-bip39-passphrase --no-outfile"))
  end
end
