class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/refs/tags/v1.18.18.tar.gz"
  sha256 "2e534c9dba93bf21e08c5ba6744333bd535459d944e308bdf59e036f7c007a20"
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
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "51ac07d9492139442ab590ec6ebe34845478e13e3e13a106e2341c8baaca9149"
    sha256 cellar: :any,                 arm64_ventura:  "38e39240c310e5cb5f2e99d066f43d93c26eb200f870a9de39d40321852f6d9f"
    sha256 cellar: :any,                 arm64_monterey: "2e01e5de7280ea41eef2166f65b0cfc1c7bb6aada4c4328d564a1d5ef2802d39"
    sha256 cellar: :any,                 sonoma:         "a3ba9185a012c2dd4cd44abdcd7f7deb2212f6cb340a407ba030b396186b7ddc"
    sha256 cellar: :any,                 ventura:        "2999d3960fabc3232baa690a090ec59e0431bbd8950353e00e9a1868167db1f3"
    sha256 cellar: :any,                 monterey:       "09ad2a62224b5362f153264ca9874d2168d78b6aeed9f67637fa93d5695e9a8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa9e2308c5947f76112761a2442651255ee7487e298d8b5bd212bc2e06384066"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"

  uses_from_macos "llvm" => :build # for libclang
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

    # Note; the solana-test-validator is installed as bin of the validator cargo project, rather than
    # it's own dedicate project, hence why it's installed outside of the loop above
    system "cargo", "install", "--no-default-features",
      "--bin", "solana-test-validator", *std_cargo_args(path: "validator")
  end

  test do
    assert_match "Generating a new keypair",
      shell_output("#{bin}/solana-keygen new --no-bip39-passphrase --no-outfile")
    assert_match version.to_s, shell_output("#{bin}/solana-keygen --version")
  end
end
