class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://github.com/stellar/stellar-cli/archive/refs/tags/v23.1.3.tar.gz"
  sha256 "cf7243950a5da62f5862f8f2343cf13f1c1b04e0998181d5fa25bdc799aa6f92"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7d08263b89dec17d444688ce9b471b36bdf57c02f10c3ff1efef741d6c96bf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "072ef5656968cce7b2f6724d5956baa044142902ac8fd4d48d23ea26ab35125f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4c5d37012c91724cbd6ec38e592a6beaf5b4bbd76c922a9b03b9d96ab2374a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ec45b53f94dd3f54ad31d91040725b4192bee3b417e6c44cbc69ff3606f4a01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce05d32d9c9fdc06f85462af0cee9bf1dbfb06938388e65631896483315bb3a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60f5753a8b41429f2f2310385ae039046770396bdca44eea8189a786e845863c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "dbus"
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", "--bin=stellar", *std_cargo_args(path: "cmd/stellar-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stellar version")
    assert_match "TransactionEnvelope", shell_output("#{bin}/stellar xdr types list")
  end
end
