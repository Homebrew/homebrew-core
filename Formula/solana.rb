class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/refs/tags/v1.7.13.tar.gz"
  sha256 "e89af646d14bf5e7d1c8b36dd988b09b7d8b7d03bdbaeb7fdb5230ee6d530191"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c890067e32429ca59734f7a46542fba3ba6039a507e5dc9e94f466fc351ed0cb"
    sha256 cellar: :any_skip_relocation, big_sur:       "6b6d1c71987398218b61418b2b3c36333acba6bb873d7e7fea3a37fca2f11e11"
    sha256 cellar: :any_skip_relocation, catalina:      "0e6e51a0a38d5bb6e4718dfbbbfd40ec3816ee1927a84fd8a474b6b280c4fc84"
    sha256 cellar: :any_skip_relocation, mojave:        "2da5367bd0e496a2561a7a406f08be05fa579f751c9b81a9201d022b40be2aaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c5d1502cdfb5f78b3fd7e2da8e90d088c5f8b4d0e36037a43c51a0c0feb4145"
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
