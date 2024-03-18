class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/refs/tags/v1.17.27.tar.gz"
  sha256 "420d6694f192298713ff19418ea89ba936ae0cacf3d5efe60f880542163fa23e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7fdd781dfaca2832bb9373337ca5439fb3edf29336ad43b94d1b39fa3473c7c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa687a3ae3b238bd057919492abeea06d2e10731f81e0dedcdc4377a95e1862d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50736ce8dc6296722fdf2f6701a1627cb0ccc81f5cc2c75e14500751ca342f03"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9521bcfacc3f1eb47218a3b7762a35fd9e0922ba911a75c693bc04a6e6ee3a9"
    sha256 cellar: :any_skip_relocation, ventura:        "e7bf1296b2d29ce8265b0fc941f7a5fba3d48432f9441d72b8a3f09ff05d0960"
    sha256 cellar: :any_skip_relocation, monterey:       "b2e01d9e53e8d2c89b367febb2ea1672f2310fb221c580ba73ed06e5b893d131"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8a0f34c06bd746cf575cdc1aa2ce57d05fc27fb20c423f631dca30ffb8d3fa8"
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
