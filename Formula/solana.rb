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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25c20ee4fda0a73ccdf2360ab0612a306d655bd555e2f7aed16c952eeb953686"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c74e3415b03ed02fb6fddd6532013bf576d796be3537270fc61be803a72e4fe"
    sha256 cellar: :any_skip_relocation, monterey:       "b99b111d918ebc53ea2dd66e6d7618f4fde0aed8d4b1099320b608627c0832dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ee48b599e238bec50792b0ea8eda9fd6c7fb8bce0c0bd6711b1c804be18e063"
    sha256 cellar: :any_skip_relocation, catalina:       "4792e2f12cbf9f0b681b88a4534e658cac94ff04b43039048f19c4e5b643ad72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9aa2437566fd0f65e549db75dacf1aa46aaae299bf879900dbdda59544953931"
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
