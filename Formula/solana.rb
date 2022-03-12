class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.9.12.tar.gz"
  sha256 "93a8705090eb329e5ba2ea1416da84f48ce667de379b0af13e85a7e14ed1c18a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "effbb8893ea142b055eb430f59c84b6e0e8c0540664702410ef0202cde73a24e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22271a9d90e27b095e862902d4bda547813158088305348a34137e8e2f8f508c"
    sha256 cellar: :any_skip_relocation, monterey:       "422396a9005f88ddcdeb97b2f2b2f038feea54fa5e2ddf44dafbd4bb151541b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e83508ad17e8fe5936078104cd4b0fe82c6f6018b725a3326e906836aa63526"
    sha256 cellar: :any_skip_relocation, catalina:       "a4b82135e60fa585472a0a16369b4f3a6780db6b051dd1d9517ced5a9e0dc670"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8f74c30d8f2530393241ace9ed8fc1355fcd378ff5ac8c5f7b50914b0de4287"
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
      cd bin do
        system "cargo", "install", "--no-default-features", *std_cargo_args
      end
    end
  end

  test do
    assert_match "Generating a new keypair",
      shell_output("#{bin}/solana-keygen new --no-bip39-passphrase --no-outfile")
    assert_match version.to_s, shell_output("#{bin}/solana-keygen --version")
  end
end
