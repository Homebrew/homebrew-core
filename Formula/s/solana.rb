class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/refs/tags/v1.18.20.tar.gz"
  sha256 "909000aab630d73c566f1573436e6a656e80528bd57a067e79e80fbe58afcd07"
  license "Apache-2.0"
  version_scheme 1

  # This formula tracks the stable channel but the "latest" release on GitHub
  # varies between Mainnet and Testnet releases. This only returns versions
  # from releases with "Mainnet" in the title (e.g. "Mainnet - v1.2.3").
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]
        next unless release["name"]&.downcase&.include?("mainnet")

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "168118e9784eea7ef94a36a367416b4dbe98da42e89bfad8a8bc489a779ebc1f"
    sha256 cellar: :any,                 arm64_ventura:  "037cfec9e920eaf2e0a652e03322b76acd24f205e2b05130c1e07c5c140937a9"
    sha256 cellar: :any,                 arm64_monterey: "1ff4d05f366991dfa681cc1f7e046c5746cf62c6cddbad6db59eef620b4edab4"
    sha256 cellar: :any,                 sonoma:         "2cf2631de64f4aacad3a4f5acbe6ffc9b59d3befcbbfee828b55dbad1e4666b9"
    sha256 cellar: :any,                 ventura:        "d78429af763e704efdfe3dd53dd06bfcbdca32d3aa0a72e22a982585c8824c7c"
    sha256 cellar: :any,                 monterey:       "bdc8dface8e33a0e6fc4becaae4b666d503a3886fc16854abd227a5a201a339d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "890c16d789fd565c7b869cc0cab9ad7b18b12f279f99a2c8fdb14a2ded4e6499"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  depends_on "openssl@3"

  uses_from_macos "llvm" => :build # for libclang
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
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
      tokens
      watchtower
    ].each do |bin|
      system "cargo", "install", "--no-default-features", *std_cargo_args(path: bin)
    end

    # Note; the solana-test-validator is installed as bin of the validator cargo project, rather than
    # it's own dedicate project, hence why it's installed outside of the loop above
    system "cargo", "install", "--no-default-features",
      "--bin", "solana-test-validator", *std_cargo_args(path: "validator")
  end

  test do
    assert_match "Generating a new keypair",
      shell_output("#{bin}/solana-keygen new --no-bip39-passphrase --no-outfile")
    assert_match version.to_s, shell_output("#{bin}/solana-keygen --version")
  end
end
