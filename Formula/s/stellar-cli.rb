class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://github.com/stellar/stellar-cli/archive/refs/tags/v21.3.0.tar.gz"
  sha256 "3bbd1eba92ca5f6dd451a8606520b40cc71e2796b0efa32303c52a7901a2a944"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", "--bin=stellar", "--features=opt", *std_cargo_args(path: "cmd/stellar-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stellar version")
    assert_match "TransactionEnvelope", shell_output("#{bin}/stellar xdr types list")
  end
end
