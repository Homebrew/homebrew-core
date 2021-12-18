class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.9.1.tar.gz"
  sha256 "aeb53aed1f7fd796cfc00a936d4a2ff9a4e784f66e538f993609e404877066b2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5720653fb2f15817dc898548fa26083ed641a87ee67f43d5a162c98458d6647d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bad27307b9563cc565bc60f9d186e59ccbaacfeb304ea5b01647f2c6594a09a8"
    sha256 cellar: :any_skip_relocation, monterey:       "88792f3fe304a8e99ae6572c477a21d2c980d71b858d9dacabf755402879ccf7"
    sha256 cellar: :any_skip_relocation, big_sur:        "89a552c8ca115e325ce882ec812659a9f2485ea4ce3b321a336701243a71bb9d"
    sha256 cellar: :any_skip_relocation, catalina:       "c9a20580876ebc3de29be301d19d3070e27cfd861a0031f94f69c26be2c470b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "052ea665f3be1d90f445b846e871bea504ffa2cbb36e976be5402f422b1bf373"
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
    assert_match(/pubkey: \w{44}/, shell_output("#{bin}/solana-keygen new --no-bip39-passphrase --no-outfile"))
  end
end
