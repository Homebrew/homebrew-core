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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "485304d958dfb5d600aefcfc3a21ee01bd945ea6541e63d2fc6ea9df74fbc778"
    sha256 cellar: :any_skip_relocation, big_sur:       "51f4d134efffb4a4540352d023f11d41f5d009c4aff96d2168ccdf9ba8d51f79"
    sha256 cellar: :any_skip_relocation, catalina:      "e4b03e4b49d11c8470f2840d4a02ec6064b9f8d16cf72049e7e1918c5221cb39"
    sha256 cellar: :any_skip_relocation, mojave:        "492571db8917742be619a29652b9a48a34b64e7f1f7147e259290f64b056015a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd202a01d453fcbd4942f98b906a39e9e9bc595d3b369a0a21eaeef978973a15"
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
