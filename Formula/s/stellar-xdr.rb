class StellarXdr < Formula
  desc "Stellar command-line tool for encoding/decoding XDR for the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://static.crates.io/crates/stellar-xdr/stellar-xdr-30.0.0.crate"
  sha256 "56f2fb2008b42fc746c0f6b46e375600068dd91f07748e9f1737c6341a2255f2"
  license "Apache-2.0"
  head "https://github.com/stellar/rs-stellar-xdr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7df455c39a5d19caf64816b449f75b564b1b4130f8372e9a651a77498e852c27"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "877812c50fa1ed44e6ba69f281360fa7dcd488d7a7e61b471f6e9860134fe9f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d1b01be62559eb0a062e882495b690df522a25e25cb840616e33d7ac53e571ff"
    sha256 cellar: :any,                 arm64_linux:       "a2a216c386637f1039aaaa95bf60b9d0ba7256eddc8b65e8462a424dab2c41f8"
    sha256 cellar: :any,                 x86_64_linux:      "c4bd1024d1105458c190081805cd3f7e6347f938ea93d06512a8250bb2fca20c"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(features: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stellar-xdr version")
    input = "AAAAAAADJH/////9AAAAAA=="
    expected = '{"fee_charged":"205951","result":"tx_too_late","ext":"v0"}'
    assert_match expected, pipe_output("#{bin}/stellar-xdr decode --type TransactionResult", input, 0)
  end
end
