class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/refs/tags/v1.14.28.tar.gz"
  sha256 "21b9a561d73f6a0b043bac0ac46c2dfeeb43af41bcca68b290e9f2ee6af0b421"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef6e7d6dc36d779bed6ab61be09366900149cec9105b4239f918c829678738f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c7bdbedb19c17381196b7aa6c3839ad99527c325f541d72e5805f16b56473e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f887e2b6111bb915f881ff8db2b2f7b29bdbf80618a3f8f4659cbd81436ce799"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "355fd89e938ed7a44444e3f8fdcd6e37cd09b572f8c381c2860e26265bf05046"
    sha256 cellar: :any_skip_relocation, sonoma:         "105221474471674968de02adb0789013aad1e5a4314c2cf7f32473cb723bbab2"
    sha256 cellar: :any_skip_relocation, ventura:        "c6ce56b37dc76bdfb529cd9ffa254b385e7044263dbeae427974a085f250cda4"
    sha256 cellar: :any_skip_relocation, monterey:       "d74e98e5a45ef44e852fa604b5859c91729134fc25e1d09a8f67f07d1a538d0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce9744a087c23638320bfc173b1057e5aa395b0e060bfed6890d2495d4e25dab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d16eac589a545076a0d1bae02125076ace47a2542945340d90660dfc6832a35b"
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
      sys-tuner
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
