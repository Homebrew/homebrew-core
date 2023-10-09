class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/refs/tags/v1.16.15.tar.gz"
  sha256 "c2e34f68cc4ca0f58b6d8120dcf362712891223db533a2477d38727fb60f7750"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "18e2ea97b18010dce48aae64763ef2b1e89e3c11a60d3e7db4b86b61bd652fc3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a523080113107e7618ed9c9fd7e545e51ee1993ab108a57e3c630d4242b8ebcc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00440d0355149d8f1f3081a771b50c31e8742c7fc0c28cfc9e8330bce56b4151"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f8382cd2f6acb570cfdb4fce94e1d1147ded84305983cacaafaaca0f0d8f315"
    sha256 cellar: :any_skip_relocation, ventura:        "14fca07130f3e19efdcdbed4b387fa59ae0b30a39f34d40e5e81284062560a93"
    sha256 cellar: :any_skip_relocation, monterey:       "153a0c33d0013857462f1dd7a0c0980a0dc05aa99d3e74c945f35997d0126262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d363675da638be7f857ecafd0d205e764924a1a59fbb9cab60a7acb1e6f5365e"
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
