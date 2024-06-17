class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/refs/tags/v1.18.15.tar.gz"
  sha256 "ee6902b16fdfcafa81f253bee6d21b282a9484aa7e15b4be0cb7d54081875ab9"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e5e7d9262548f6aed95c10bfad788a8e78864018d9efa82ef4083fe5c80be66"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54eebe330aa808df36c06752156206f8799971d656d73f5a327c6c7f35ddca16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4b8efb32db92aff333b5158ce69ff1f20d4e9cb4a5adcfa36d34a788cf48c17"
    sha256 cellar: :any_skip_relocation, sonoma:         "aaca873459ec736bf186e1383c681661e684873c69b91fa28a32c279cea41fea"
    sha256 cellar: :any_skip_relocation, ventura:        "36626eebfec1e794a5be070da8316dbc9faeee04dc47eadbf12252a251bd4301"
    sha256 cellar: :any_skip_relocation, monterey:       "e40f1bfb25a35562eb9e34fd7310cd716e3da9b5485801de8d5cb365ac108854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bcd9e2911df6d602e5f24d8bf54e122fdd238bb9029e5a0bd661965daf5b4d6"
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
