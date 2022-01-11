class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.9.4.tar.gz"
  sha256 "6a01faca50d4507b21c63e7e2ba4351c5be7765796aafc45b02ff32d3ff5d303"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8cc98a9734fd0af66b7305573d08aebbf21ff4cfd157334dd8cf447c80018f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "175bfb26ddf2a5854fd06998972dcbf1e96e4ead70d2c931aa65ed722f6c4734"
    sha256 cellar: :any_skip_relocation, monterey:       "f6ab03696d1cd7ec5b33c1f7340f1ed27ad30875edbb36d31f977fb7776c6594"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d6ab547741b9b6c4510c01039ef815dab3e26720ccdb7c93798ae1f93f4a553"
    sha256 cellar: :any_skip_relocation, catalina:       "f5d103d689b988c5e6d51efd1ff58aaf1b82c456b8e0fe0ae22d6b4651b9b9a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11f1dfc1e2b6ad7e2a1b9ddcf22ccfcb1d1532396c9e9bb74b4bc99dd407b01a"
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
