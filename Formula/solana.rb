class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.14.19.tar.gz"
  sha256 "551b41386fcc3fa65f13ed78fddd1b96a59b4dceaafa88a5e77dc3662e8ca72a"
  license "Apache-2.0"
  version_scheme 1

  # This formula tracks the stable channel but the "latest" release on GitHub
  # varies between Mainnet and Testnet releases. This identifies versions by
  # checking the releases page and only matching Mainnet releases.
  livecheck do
    url "https://github.com/solana-labs/solana/releases?q=prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >][^>]*?>\s*Mainnet}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3901045c5b56b96ab9995028390c79a1df84decb6871784e406ce28c5a7f3dcc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "454c2495391beacf022a232af9f1cceb09d824bfc2147e8d6522390fcf884dad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76ecf4ec4e6adca8d31eb9ba1aed5ffe134f01c3677d348df8064029be6ce49e"
    sha256 cellar: :any_skip_relocation, ventura:        "1eb1609151ac38d27507bcd37ec3e6c3811d6b738885f1c6eaa344d40cc2e3e8"
    sha256 cellar: :any_skip_relocation, monterey:       "fc6b6a0ed7b6a700c0928673b64b330f5920795e17c3e5525cff93375c4b172f"
    sha256 cellar: :any_skip_relocation, big_sur:        "593135e01bbbde00eb4e16cd19c45fb3aa844a07a1b38d81e155d803420b2bbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16f31f2e03ed66e0d802cb70048fa49436487f232cd46b5a60cd203c9ceff070"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
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
      sys-tuner
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
