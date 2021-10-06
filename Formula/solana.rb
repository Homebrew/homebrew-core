class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.7.14.tar.gz"
  sha256 "65b4b9c3ea53b3cd06f905c685b938fad75f675ee9c46c044474d3c1302287d5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "998a03d316c9f4b4be539923d69871639965bfa3a01d38d49e3d8c177955c3e2"
    sha256 cellar: :any_skip_relocation, big_sur:       "bd3fb3c6d26802445b9ae1eb411e05c809f8585ebe922996a84f29df546fd3f0"
    sha256 cellar: :any_skip_relocation, catalina:      "c1c8ad375bef7d97085595b3d4f77e37f73eec2594ebb55e3259b09cf05c304c"
    sha256 cellar: :any_skip_relocation, mojave:        "d2466a529e47627a74c371c537df661bccfd8d415e5b8fc76bbd1e544ee68c1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46c7ebfcda2d771e53c9b2888cfe9133704285c88e1a45b690d5f857cd413572"
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
