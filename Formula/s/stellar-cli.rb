class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://static.crates.io/crates/stellar-cli/stellar-cli-26.0.0.crate"
  sha256 "dbbcb1f8c173996ead172c7268807ea1d909099054307d013b71683a5400a9b5"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90f24ad74dfa1add658c6e8dcc8b141b0aba68e4efad3ceb1b25df037dae7fc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c90b42b18bb90fac7d18e508ae10a10870a0cb5504d6e56b3289afab12242985"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e284b63d546ecefb6f24939885b53a4b7e8b3f260058a778f59a16774c65277c"
    sha256 cellar: :any_skip_relocation, sonoma:        "eca35b07791d26765e2b12433b43cb2a077f18f6eea8186710121eb8b67e9700"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d334485350240afc9d3d53a47b5346bba5f67cd27a90d47733b714bc39b55b80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a27a4604b478800b19f72b375f2c86438dc7ba92f8dbb769cad2d7a286cdfcd"
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
