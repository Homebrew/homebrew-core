class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.13.3.tar.gz"
  sha256 "75a10aee455f6833e2cc5fd68756a934fe73bda1683947c42ac6b61c30f88a82"
  license "Apache-2.0"

  # This formula tracks the stable channel but the "latest" release on GitHub
  # varies between Mainnet and Testnet releases. This identifies versions by
  # checking the releases page and only matching Mainnet releases.
  livecheck do
    url "https://github.com/solana-labs/solana/releases?q=prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >][^>]*?>[^<]*?Mainnet}i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2924d39010dc8be50ba5a90afba60b66def869b13dbb0b05a8815976da02f147"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe26d70c6ae7a5319b18a768898d62b84c26ab35ecdadc8373814e114d8ae374"
    sha256 cellar: :any_skip_relocation, monterey:       "e9929eb8113a54f318e7b92f3b8ed426b437c88e7d77e925e2930540d06b31fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "d967eca15e02d7944473711129fd392fac4d8dd5947768997919fced218891f9"
    sha256 cellar: :any_skip_relocation, catalina:       "8990ce0c0c9e578ad20e45741c0a2873225c687de7ff54fae33565f90c8aafaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a97a30a71ed7ba3a3640f0bea85053be424d70cc570a387c2bb7f8ac3dac510"
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
    # Fix for error: cannot find derive macro `Deserialize` in this scope. Already fixed on 1.11.x.
    # Can remove if backported to 1.10.x or when 1.11.x has a stable release.
    # Ref: https://github.com/solana-labs/solana/commit/12e24a90a009d7b8ab1ed5bb5bd42e36a4927deb
    inreplace "net-shaper/Cargo.toml", /^serde = ("[\d.]+")$/, "serde = { version = \\1, features = [\"derive\"] }"

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
