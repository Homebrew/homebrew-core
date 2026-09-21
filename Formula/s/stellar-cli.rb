class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://static.crates.io/crates/stellar-cli/stellar-cli-28.0.0.crate"
  sha256 "1772d04d1bcd1bc3d2aae81932f3dbad84bac9fdf8b4c76b72aa4eb11394ae64"
  license "Apache-2.0"
  revision 1
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "02536579b40be413d1e2b0f6f17c784751d2b18bba4fd7df66c0561d835918b9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "84a177a0625c1a667148b3ee18c69ac9b5777b3f19cad6b121e9f51b19e3fc4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f39567597c1b4549a2733b4bbfd30c13ab7f1ffa7b9037919dc1660dabd008b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "4ea22d68e99744ffe91cbf64d2b7f84f3ce991479fe18ff4f58a2a6d314e3652"
    sha256 cellar: :any,                 arm64_linux:       "01d62b0a8bcd390df22b3270968504c7f94b9a0ca040f8d86e564d024b51ebdf"
    sha256 cellar: :any,                 x86_64_linux:      "077514812a83ba583e2c74062dfd8740e06056ea40f0866b719a2b365f37796f"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
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
