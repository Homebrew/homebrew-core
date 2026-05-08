class StellarXdr < Formula
  desc "Stellar command-line tool for encoding/decoding XDR for the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://static.crates.io/crates/stellar-xdr/stellar-xdr-26.0.1.crate"
  sha256 "ea6e29c7e1f071c2767916460d006668197843d5d93f0ec8893a26f72a14f595"
  license "Apache-2.0"
  head "https://github.com/stellar/rs-stellar-xdr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c94ecfe8ea38e810170e284a13f00a4e8487d141d231cf8b2c58643c8c0e98a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0ce42a35f3b927e09b6a088769f63613607b0328b901edc006708c525a9e7a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc440aab09b4b8eb5ce8ff6a4fe5a2d8c10c51ca99e804db3bfcfe5fe8621354"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1c12facab82bf38a22fd7413a33e301a72dcb488cd02a36cf4eb78827ceebc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ffc71f7e12c7ffb7da93eab39a35120b6d77709b24e0ad7f90bf60d3ec5e25a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58ad7315b2004dcd9d481127efd8ef5b1d5ffe7f88be42eee45b69a021b570c8"
  end

  depends_on "rust" => :build

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
