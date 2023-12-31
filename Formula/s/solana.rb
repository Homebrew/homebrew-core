class Solana < Formula
  desc "Web-Scale Blockchain for decentralized apps and marketplaces"
  homepage "https://solana.com"
  url "https://github.com/solana-labs/solana/archive/refs/tags/v1.16.24.tar.gz"
  sha256 "ff2734b38b08742bab94368db5c4b6a108daea9250e5e84b2ce2fb6b378e5588"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4372ee6266581d5e08fa2e0e035fdb4b7243d8b55d827446e9b0054b49dfc0dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db5b2bbe6e16db7e1b7dc269aa50e2591dc6b3ae685e36b4ffc9db7bf8637058"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0548df38e3a785b034bb284dee70833fba8d6898153f500c7d9d59c0bcfa2fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "d126d1519f0dbb623cef5d56b85d1d3993ae990ac764ac615f04e81d8dc5a266"
    sha256 cellar: :any_skip_relocation, ventura:        "ba5e540ea00daae93c8647f775efd1597685153377495cba5e5c6d8551758b20"
    sha256 cellar: :any_skip_relocation, monterey:       "07330abfb8dae4e14a70d029c0fc993d9b9dc9e6833545b010a288f73ac9347b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0c9e159809520a421ef734ade5fa147e0c37618ed3ceb411d7daaee0459b7ba"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "systemd"
  end

  # Backport part of upstream commit to build with newer Rust.
  # Ref: https://github.com/solana-labs/solana/commit/9e703f85de4184f577f22a1c72a0d33612f2feb1
  patch :DATA

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

__END__
diff --git a/sdk/program/src/account_info.rs b/sdk/program/src/account_info.rs
index 372370d0e15a0f2877b02ad29586e5b352438b24..3db3e9839b6535786e60be5602c03d0c909bf937 100644
--- a/sdk/program/src/account_info.rs
+++ b/sdk/program/src/account_info.rs
@@ -182,6 +182,7 @@ impl<'a> AccountInfo<'a> {
         Ok(())
     }
 
+    #[rustversion::attr(since(1.72), allow(invalid_reference_casting))]
     pub fn assign(&self, new_owner: &Pubkey) {
         // Set the non-mut owner field
         unsafe {
