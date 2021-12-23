class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.9.2.tar.gz"
  sha256 "e04a047739c00ccb7ad5ccf0c71d249be25365ae14ff0fb3fffad92209b2fd2d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "806072124ebcac7f62f7507b0816c751261b397fce090f880e1bde9f4144aa46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e42b5d31620f5e8faa6184d18c3d63ecbd614fa012fdaadb77ade4259ff3511b"
    sha256 cellar: :any_skip_relocation, monterey:       "cc13d154dbd9a67dc8a903ebb11121f2994d73f8eae5cd78e8ba252debd07a3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7755680673b32235a56d79f10d97e6c14009025eb11a652b186f134f53b295e"
    sha256 cellar: :any_skip_relocation, catalina:       "8c7e513a06cb3370419c0a4bace7c67d05e6c3189b14fce69f8089808293ef93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "547e2640f9347a11f45639827c4c1b25ea4d8c7b43f460ff94e83923f06845a9"
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
