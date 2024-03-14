class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/refs/tags/v1.17.26.tar.gz"
  sha256 "8b6bdc6805f374d5f29252db9e1076a848348d4538f5c64fb0d7ceee669f012b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1060628863bba3db4dde2be941e671152dd3e4b1650b51502315af5e443587cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21760bb0d0254004885da771db75f1b6f916c0882cac4906b002f94da2131a9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af97bf8d57835ace017edac579b442724a2d1290e57e58a53c5b262d39224077"
    sha256 cellar: :any_skip_relocation, sonoma:         "52f7366bf18ec15583b7091f7fec7171c2e5b6497c13f9b13812466fe8dfc26c"
    sha256 cellar: :any_skip_relocation, ventura:        "9de9fb7503c85d42789cda4f45be444bf39d68e27153c4cd8a854d899ac9a616"
    sha256 cellar: :any_skip_relocation, monterey:       "cfcb632bff602feed5d9ea1f0fad1f8233cb97cf18926e6637b1aa76067056cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "770eddb59584309a277a0872dbd0de49dd6f7ed829993b251f5585fc8a9eced3"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

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
  end

  test do
    assert_match "Generating a new keypair",
      shell_output("#{bin}/solana-keygen new --no-bip39-passphrase --no-outfile")
    assert_match version.to_s, shell_output("#{bin}/solana-keygen --version")
  end
end
