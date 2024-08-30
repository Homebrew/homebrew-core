class StellarXdr < Formula
  desc "Stellar command-line tool for encoding/decoding XDR for the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://github.com/stellar/rs-stellar-xdr/archive/refs/tags/v21.2.0.tar.gz"
  sha256 "b2ea98e54642d069d67b2b21de532a405c5b72a6ed062796cf504913f825c38f"
  license "Apache-2.0"
  head "https://github.com/stellar/rs-stellar-xdr.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=cli", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stellar-xdr version")
    assert_match '{"fee_charged":205951,"result":"tx_too_late","ext":"v0"}',
      shell_output("echo 'AAAAAAADJH/////9AAAAAA==' | #{bin}/stellar-xdr d --type TransactionResult")
  end
end
