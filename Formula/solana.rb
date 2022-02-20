class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.9.8.tar.gz"
  sha256 "a8376061f4b38fe1dbce737f0e774da7caeb3389d682f6b30d05dfcf1e0fecdd"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66f1317a121635fa7c27cd5d7fdd6480d934e9e8001c3cc446ad04ec674a3dbd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cb4f4d15c30e159ef35f6d2ea62e137063ffff59ad6d7257d757afbeb76db93"
    sha256 cellar: :any_skip_relocation, monterey:       "c8367cb6f0ef7a8b87af06ec3190ded5f2d9448b80ad57b4723abea43c5294cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "eea44d9420e3d49c63e78c6bead13d4decd71747424773152dfbbeff3b2fe3f2"
    sha256 cellar: :any_skip_relocation, catalina:       "b460895ba1ada7e2527b7b84181f68b0ba1b1aa13e28441fefe2fda4aa77ad1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6647ba3fe6afc21d7e3873c883472654ad1d19ccb848ab03452e4ef2d7c11955"
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
