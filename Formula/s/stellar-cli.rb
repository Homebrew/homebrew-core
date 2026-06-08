class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://static.crates.io/crates/stellar-cli/stellar-cli-26.1.0.crate"
  sha256 "3fba46c930d691dbbf1c93be181296f772f9049c36f703d62ab5900453993cf7"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8be0cb5f2a473d40195627692600ea35fd84ed1214fa9052905bcf7882763652"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4833daae6cb690dcbefd35d0b9f1facf691994a12ab2b97e9549248c613b88f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9f78fcb086fdadd71c342eeca31b79702a73a9521e5e98e155a2fbaecc6d6ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "9381aa040ac2e1c1582d47bc7b396501c46c4e0c3886146f1b3ced4115b32174"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a305a8873f20c03fa7cbda5201bfedd76b036089bcfd927dc5122c4842d7427"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02553f6a00683f127ddf232e98f0d49f5b861e7ad6a98505485b9221218e177d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "dbus"
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", "--bin=stellar", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stellar version")
    assert_match "TransactionEnvelope", shell_output("#{bin}/stellar xdr types list")
  end
end
