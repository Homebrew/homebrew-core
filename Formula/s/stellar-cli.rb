class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://static.crates.io/crates/stellar-cli/stellar-cli-28.1.0.crate"
  sha256 "ceb241c122707ff7678e07c3459d43714eeae6af0c82c125f6a448e856805139"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b010bc8d9b4415b010414502823e305d909d9401d97bfc50589a5227467a961a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a61e1fbc0be2f7f414bf9f84971d8c1696aa805a21fdb517c0be95d521149ff1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ed9693f2d9bb503cec192d77017a94fab8a49101edcca2b4909993632d8074ca"
    sha256 cellar: :any,                 arm64_linux:       "e390eab10ef0680a76bebce46940a378614dfc2cad80667e638e646b5bf0eda7"
    sha256 cellar: :any,                 x86_64_linux:      "fb05632afde89d60887f4f296c53a66efdf920e20a2a491aebade2ccec29785c"
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
