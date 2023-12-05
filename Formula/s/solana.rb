class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/refs/tags/v1.16.21.tar.gz"
  sha256 "4b81e6c3c1458a17394f2a67d39a5a9af17501eef0f6dce3cff1296e8155b03f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d187c536bb1045326f85a57ad3338e25f2fcb15e60a58bcf9c04555e59a82522"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83cfb043afa6a4e6db022d26c04dbb22b56be26ae323464a517502a435945eb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3720210b63bb7cf6d2a670fd8b3175e7d13441683697daf665d8d9bd2bd9e27"
    sha256 cellar: :any_skip_relocation, sonoma:         "1532d6d50d9cd1dd2d0d84def4dd0905eae9bcf167f9a6a719bae2de07803343"
    sha256 cellar: :any_skip_relocation, ventura:        "252d0dca8ad0706c6f89a30967360f834ae1925ba7516075268916a612e29acd"
    sha256 cellar: :any_skip_relocation, monterey:       "a3dc0d11eae059053642234ff7745da0125858674c55bf0f7f7430b970ac5a37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52d064d62ab447c7c7024c1df19f818f477ce0c710f94b5d2547fee7f2eea574"
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
