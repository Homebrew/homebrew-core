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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "829b671df4802c8e03cce40ff19a2be9f7819a9997bb16ef0692702aa59ce0c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8eeef7e3b42ea9bc586c90f5a97d67a98f61742e50b20da56432f2bd768bffb"
    sha256 cellar: :any_skip_relocation, monterey:       "19cd1be6f8a74c064e679e352eefaa3f353146ec7682d5b59384b2aa02577c08"
    sha256 cellar: :any_skip_relocation, big_sur:        "14c319801320bb19568f85ac77510612c1d718dea421e4a83ec347f445ac4e46"
    sha256 cellar: :any_skip_relocation, catalina:       "d8f544ce447c6598336a3f754f72c3bd4b0bb8e8e8f5b1e98f0583be1ed447d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abbb96cd620d178652ecb99187d279a85514761d945435edbd4513726dae5c57"
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
