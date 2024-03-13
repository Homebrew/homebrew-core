class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/refs/tags/v1.17.25.tar.gz"
  sha256 "bbbf741e1ea3245fcce5794427fca80486be39d2670824ffe4f2a0f40b457920"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f579acaebac730e1e0042eaf0dd9c51a0a2c421523266585eb5b99ea9f560f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "effc16ddf2593aa76408ccc26dc7463a077413c1bfa86bf609b952514c5d5fee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f63469f22c8888516fd501baafc75f2bec1d11f796aff844c27d0502259edf7"
    sha256 cellar: :any_skip_relocation, sonoma:         "d483e1cdf5940170d78a99bde735f1d15160fab630070dff5a00f6b7b732cc8c"
    sha256 cellar: :any_skip_relocation, ventura:        "224925d3a29592e56f62bcb964deff5d864ed389978af68f1e2826add9964a4d"
    sha256 cellar: :any_skip_relocation, monterey:       "1cf95d1bfb1a991f8afbd3a27fd5e15515954332103df639ed93a1e84fa76b11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "281112cec62771bf72bb262d71ca757ad379bfbaaf49538ecaca8603338bdb27"
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
