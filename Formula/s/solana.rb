class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/refs/tags/v1.17.31.tar.gz"
  sha256 "97623297c58fd40037c2defcc2f7398308ace36a71f3ea9899d46cfe705675ce"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7af7305b91062c5015f0287c5364ae4a9aba07beb1199b0b89bf8fe3ab75cb87"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c6a5caa540970224f5320710ea99c253612f7e54db6fc891f9cc9bd89a40925"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b8a6bdeaed843062e15777d8bb447023784b2a2dc2a2a018b16b2f0313c9b42"
    sha256 cellar: :any_skip_relocation, sonoma:         "6787f2f01d2caf8409f442ea45362cfdbb7dd1f19eaddbc88b9281c3fd64f05d"
    sha256 cellar: :any_skip_relocation, ventura:        "c0537f952bcbb11830abbd388b3a0fc2bf4e2eda281dde9970363cfc92415e85"
    sha256 cellar: :any_skip_relocation, monterey:       "75a79dc3e01dbec38f60f2e7493cbd527bc805c2a6c274370aec6ae01581b03e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a76ff86ee5e916955a728975a4e22b70d4dd0909ee8db9891c097a9575e22c9"
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
