class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.13.5.tar.gz"
  sha256 "62db6f48488413cf727c1f2525dc1e56b817c4365f40d75773ca4760f7eb71f9"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba204e77448e03611695d73cbfa8c05b3a4c35cc7ab2365187efedf1f646f33e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95a80b31cba10024c8c50ca4e613dc685df017e4b5d254ec6dc0a0e7f304e53a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c90cedba15b0dbd3fd969552116d4d4841767cf09d6dbcb624afe78c64c992b3"
    sha256 cellar: :any_skip_relocation, ventura:        "50668b5c1771d655b268ad31f6f55512d4abbbfcab88c9d205c002186bc5a02b"
    sha256 cellar: :any_skip_relocation, monterey:       "5fb72a9fb0695d8b8598844ca02bca150b93ceb917352f99de6ce926852b1eae"
    sha256 cellar: :any_skip_relocation, big_sur:        "520608d3fbe309d93663b65a6532ef787d51b09263f4c0e41a9923bfcff45a25"
    sha256 cellar: :any_skip_relocation, catalina:       "865efe6a20aefb95d5538e43b510ed440e920a409a0e4ceb7bc546b75b0b355b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4367eff413414d0a8b6d8f05aa3effbec10362f82feb8361438edd28ea8fffe"
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
