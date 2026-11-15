class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://static.crates.io/crates/stellar-cli/stellar-cli-30.0.1.crate"
  sha256 "c33c65392d9227c4628ecbb73041ae62bf81b25579badbabd27ebbbd6fa58992"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fd612a77fe8bb996d7dbe8805507de1597eafada542eb81b6cb0beb58d348aad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3c751a89d17e98c91c3593ec845ed83b4d7f378288c9e9b6049beb2a7f26361d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1f267d407b19663e9202236e9fa6ded0006cc431d361400be6542444269543df"
    sha256 cellar: :any,                 arm64_linux:       "f4a9b18920f7cd8fb030fed21794f577f29b9b55c9e08dd0019be4827a2ad2e4"
    sha256 cellar: :any,                 x86_64_linux:      "93f036784808a30ed667f7fd0dc4c852cfb930276f9d4946fb01e7f6efacc8c1"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "dbus"
    depends_on "systemd" # for libudev
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--bin=stellar", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stellar version")
    assert_match "TransactionEnvelope", shell_output("#{bin}/stellar xdr types list")
  end
end
