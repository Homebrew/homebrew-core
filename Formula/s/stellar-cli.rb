class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://github.com/stellar/stellar-cli/archive/refs/tags/v21.5.0.tar.gz"
  sha256 "9d9209f6bde7ed5a68422ef3ff5cd37f16a2209c9c5b5676224a7132ccdfd5ec"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9a8618fb36df2ac69a77a3884359eba0a14fb737267631649f6f09e5a295d9fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64cc11be0010a21ca59f850f740ada377701fccf5a22e2cec671edb75ce269ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e218a5a89acae8caab9cd0610db20911b1e602e272dcefcb03ddd0209c6377a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9f5147f447727a36d6e86cfd727cf681669b0213f1ed21da2cb16e0f9cf2508"
    sha256 cellar: :any_skip_relocation, sonoma:         "67e8e90667233e0d6cc55b1481d02bcb4c8c78a1cd9f60f66e21b6a092d0fd95"
    sha256 cellar: :any_skip_relocation, ventura:        "e49d8af8a90c4ecc1b0a72ad2728e7871a66d3ee37f0a3aad1b4e9822bf7b04b"
    sha256 cellar: :any_skip_relocation, monterey:       "9d6d7dfeabcc520ee2b255a6d2d818e82ffefeaa12ddeb36e495f954e3aa72df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8eaec424f808bc95bef66c9abd1ce88475493ac8ccb4080b415c4da57da15406"
  end

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
