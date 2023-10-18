class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/refs/tags/v1.16.17.tar.gz"
  sha256 "4f486726d75a6c022c1a399d21cfcc6732029aa0ba6a14da7229e789ab8db418"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6cb15a45ba3375c68a57d32b39721c4b02b5f898176fffa47580104eed2b2ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a3d530ee15e2d75a82bd68d4f12734fcc875e38e862f7d55766244190cc605e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c37eb36828739dcb9d0954796509f8380071a3a2cafca933e4cca8bf7366567"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e5c4078a36a204453548e8f76b526482a39546a7cdd24726c1665d1654e45b7"
    sha256 cellar: :any_skip_relocation, ventura:        "ab47843b9982c70827bc5f6dc646926eaa81547388dd93bf505ba5f54e3b368c"
    sha256 cellar: :any_skip_relocation, monterey:       "81e2ac9cf6b00b4804c9869dda4e45dc75d49af853d6c7ce672d5b82300793a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14284cb30484d000dc9daddaca7b938617da177083021e11c086a97ce16dc82d"
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
