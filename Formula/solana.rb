class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/v1.8.0.tar.gz"
  sha256 "b3d9e87ce6f2a1a6da76ca6b954aac51c94d5d65ca55fa60eb807aae123ff293"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "212cbf69c58d483249719ded3814b6c23ede1cf5615df20b7f014d63aad56ce0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "266d90cad35a84c5a5bbab6acb869b1a8a114993868fd854665dbe3712261463"
    sha256 cellar: :any_skip_relocation, monterey:       "61cbe746175e14b950b66b4ca051e46768717897c16995998f1990c05ca64203"
    sha256 cellar: :any_skip_relocation, big_sur:        "111ee3902e5cbbccedfe655e926f48a2b67a1dd54d61ea0fade8ce61c77412e9"
    sha256 cellar: :any_skip_relocation, catalina:       "0bd8991781f51e9c615954b6a16f75ef0ea3f331b330acc44f9a8921dd68f7f1"
    sha256 cellar: :any_skip_relocation, mojave:         "b472efbaeaf50c046e4bc9dad505b9914feac2c5185654eabe783e72cf5bdd0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a81ba141e190b00be7519fab1924a2f15e104369e3be6166f946781068093052"
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
