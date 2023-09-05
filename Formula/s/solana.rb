class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.14.26.tar.gz"
  sha256 "27c9e1dcac14f16811cd938190edcd9bde6419de1c2caae5e659462f01655232"
  license "Apache-2.0"
  version_scheme 1

  # This formula tracks the stable channel but the "latest" release on GitHub
  # varies between Mainnet and Testnet releases. This only returns versions
  # from releases with "Mainnet" in the title (e.g. "Mainnet - v1.2.3").
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]
        next unless release["name"]&.downcase&.include?("mainnet")

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2dc54272f2cfb8d56b21ae0069ba2185ef6a258c8024ae1b970712233c0558e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e36df8d1334d992d7c9c390ab648bb6f4a764c83cd60a04b7518c29f08c28ee3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd23670a3b04b8eeb2dbf5b211d7f8363a1b33a00e2d04755186771a7c6d5486"
    sha256 cellar: :any_skip_relocation, ventura:        "720240bd7ba382d5214648d7778225a4292df2524b7c733a763cf645e5ad1eba"
    sha256 cellar: :any_skip_relocation, monterey:       "daf9f18a7056ff9bb929e71358a45eac9cfa680b338c02f899d0db944c6861dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "05dcb0134b9a8fb9b54cd42ea6a49100e09d08726ddcabdb3cb86d9146b0630e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8e4349067a045048063bef19ae4b51d445b10d74adde9e36ecc0cc5b143b69e"
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
