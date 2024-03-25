class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/refs/tags/v1.17.28.tar.gz"
  sha256 "92cf0633cdb9f2080b07412d66d31d98ac45db4c675fd111c03f2e458745db06"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2a06910276984262a1504a34254e3cec352371a6214f1a57657df3f2c24943a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "240875ed5d2154c3ff9406d3b915614440b0a0a766dc8245ce3f335443b6474f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dce245197fa68c99ee19fd7cea096ad24028dc95544028e9740c21526e9dc4a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "7806a38f7a84d70267253d406d7b0cfdaab30d36cd96935b8e7eaa658e5ebe07"
    sha256 cellar: :any_skip_relocation, ventura:        "f5ba279aa6e25e53d6c039c431e8dbbf6d5faa0a884f7eb8771e08466fad5d01"
    sha256 cellar: :any_skip_relocation, monterey:       "9540a37de5e942ac100928d0d0269a02dea0b7deee55dc867f5d9ba1e963be9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79960c979f074675565555ac2f0d019e16dbfeb17808c964153f6be9c088b654"
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
