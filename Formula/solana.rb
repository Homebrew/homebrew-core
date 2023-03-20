class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.14.16.tar.gz"
  sha256 "ade55d4178b5918fcf4b98343dc835fc255f23ec9b040913fb64b7551697fa0e"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc9e76e7d4a0beafe31316aea0bf8f584c0df4f6d8f8cc83ce5e94e6b30caa14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef51244d2887b684930b94fa21a94fe03e9fd534e0ab7b0059662f3913fae86a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "244b43390cef454786d3c43abef00d862817830e6fc981e412e6069940164cc6"
    sha256 cellar: :any_skip_relocation, ventura:        "31186b9ca510c9b8d0dcef327c2bc69e3303756a4d99e7d165757bca0c998088"
    sha256 cellar: :any_skip_relocation, monterey:       "f310881d08641bb216a0cc00bec52c6f9377ffb3f7e52c930565a88d92f93871"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b4bfc92adfa190db884042f1b0716300c3369b44f8b9b38a72b0f60881b64d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b2446264d16aaf9c7c32a0de96711e205a7f581b7cd982cd75817221414d265"
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
