class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/refs/tags/v1.17.26.tar.gz"
  sha256 "8b6bdc6805f374d5f29252db9e1076a848348d4538f5c64fb0d7ceee669f012b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8e884166ca590ab67ff659c2ebb089d1d1323548da353e7947f5397897ecc780"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dee30b3598e9ab8773213a13dd6732baf2e9cf837d51aeb3b0d98ca421126256"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c33c8309db9dd2ede98d13116dd0427e5c652ddf07398e9cd6b5ca5083559519"
    sha256 cellar: :any_skip_relocation, sonoma:         "0868f905f7300509270160de4c59fe1fa77b49ef21dee684953e33f8afa50002"
    sha256 cellar: :any_skip_relocation, ventura:        "33c663916551f647e57f42e76a7cbc9e78dd3395ce50e222ec762711c9821024"
    sha256 cellar: :any_skip_relocation, monterey:       "cd05e3ca2a1bb5cafdec9be6f00c9033cc8f02bfa86ddc88fd5cec278f50f66d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f52362a8b29a99d92b5b4d26858e4886e79550b7317b9cc9fe5ef297904cbf3b"
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
