class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.9.7.tar.gz"
  sha256 "c28ac1104efbc3536de2528a764837446763f9237f932b4f9da03d38c81d8f46"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54677710445dcaeeaea5a5075fd38da7cd4472a981580722381cd22cf3f3b570"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2de7539f233451246514e02cd9b2e8567cb18c09409810232b3cd55afd03f7f2"
    sha256 cellar: :any_skip_relocation, monterey:       "06664f31a99556b5870177b30e2776f353f612544c60cbe735b9d9f3331850d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "5bde5af4f771324d26847fc13edcf8855fdc92e09a4d4249cc455a2e9d292e6c"
    sha256 cellar: :any_skip_relocation, catalina:       "495ecc09c3671e01555277ea84a16501342a5beeef5ece4547b2a267b75ee2b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04fe5fe71d0add48f29cc3fcba545a95795b94dfbe4756a3a55918390ab6e93b"
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
