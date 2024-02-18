class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/refs/tags/v1.17.22.tar.gz"
  sha256 "3e1ddb068a11fe171120d4d3e8b98cf3f410837ed2fa5f4ba3b1491d0ffb81d1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0e677774c444e93a3d45fd997fdddc66edf256599a39abbf7779a43b44c132cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d107bd77ec59390d86d41127e29ecfeadf3c00e6224f37d62912f8f98cc22c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d95a9e7a4c4a195749ee88b15e3a0c7dccc60e546b0be5de38b2bc5aaae755da"
    sha256 cellar: :any_skip_relocation, sonoma:         "808bbd4c3b76ad5d0e41468bb6aa8647f4d12efc935d165440dc1cb3a3b4c57d"
    sha256 cellar: :any_skip_relocation, ventura:        "f220374d0b0a6a00300e2a210e673644dacdedf76b6c5b1e977c5fa8c1291db4"
    sha256 cellar: :any_skip_relocation, monterey:       "b911ac285b77752b6bdb68fa6f9527efacca90cfcaac55309258081bd68f892b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b973dd36ed04ae61bb63768fb30c1591db6bf7b7d3362d2dcb85143bdbd5e952"
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
