class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.8.5.tar.gz"
  sha256 "1d8077fea0638afec44096786146e21ea17b1a9f606cd88b03e6c18f3608ffca"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19cbf1dbaad7410a6a1029a7a7baba39394d8d4fe7a839082569473699c86dfa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f39d1433e9ca4cc5ca63448e0df872f1765ab062e6e080bd74e9fe523f72b10"
    sha256 cellar: :any_skip_relocation, monterey:       "53a45b976264755143a440e23b2eea19ec17e04ba1ee5bbffb4499718b22f055"
    sha256 cellar: :any_skip_relocation, big_sur:        "3cfc35ef0b80423e4447a85e467ab2a20c1e7bfb754501f13f96b46f849ec4ad"
    sha256 cellar: :any_skip_relocation, catalina:       "15f19bf42b61e275c25bc997e08fc94756ebf4f9e897d495ff98a200c3096172"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59c8f56a3a9afdbd3405ea581741052f44cb3f7a535fcb5c0761c875e51dcf98"
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
