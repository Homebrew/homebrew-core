class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.13.7.tar.gz"
  sha256 "97ebe8441163b269cdc55cb2ed58e5900d0f409f3c562567e08305ea66023a0c"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ba8b32fa9bef465e24a4a9c4ab3ae88654b3a01778a45029b50d8e02d50065d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9dcecf6bf2115701759fe352f79761f834f6725aa3556fad894d0ec8cb9e68f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03271d9f7a497e4434daa483f695cd3ae169d8bd19515979efb57bf508a2a2f0"
    sha256 cellar: :any_skip_relocation, ventura:        "22fd89290dc2a20b1035d01adfc5730bc191dd39d28500159e036bb6304103d9"
    sha256 cellar: :any_skip_relocation, monterey:       "61e4dc400cac5bbb6d4b1b8f4529a768628c0532b52b28ce9009aead7f7de9b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "431399438c85ca3392acd24deaf592fedb6e56f33d746289765059152d6c07c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ce116e42877620b7322f7c4d914ff91ae6a4c7d78554c379508f08a691605ed"
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
    # Fix for error: cannot find derive macro `Deserialize` in this scope.
    # Can remove if backported to 1.13.x or when 1.14.x has a stable release.
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
