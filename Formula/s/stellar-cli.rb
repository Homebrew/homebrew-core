class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://github.com/stellar/stellar-cli/archive/refs/tags/v22.0.0.tar.gz"
  sha256 "658fc88d8abe6511091f65e9ff0ad001643c916334572b054d736385be2ed977"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96973a25c2e9c1b1f2e6f2433e643d930a9ccd30669f909b752644da7601792a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f396ecea540e3761338b34b8b5883c4b28d8ee4d085ca24eb883eddab27fab9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e007a3067c819e2254572b1a3fd928379f060d2b4b736ef0ade76a79c02479f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "caedffc1652aa1cddd3b0cb3c9f728378fbac13765d5c34f35c1954765d2a698"
    sha256 cellar: :any_skip_relocation, ventura:       "a690b6f48b82ca2c187b64ca1e866ef90059da0e2d7b7a02bc03710e932147dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd594e5e89b8c29f2bcb1f486a16beb62c410878f76fd820f0825a9ffab02059"
  end

  depends_on "pkgconf" => :build
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
