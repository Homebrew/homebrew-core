class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://github.com/stellar/stellar-cli/archive/refs/tags/v23.4.1.tar.gz"
  sha256 "591f1c86c8d4b16cc4de29181943fbc05c414c443185a78c3e2fe0ef814b14b3"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7aff138361c3450fe3d74b39274c98b8aac2cb6f62a0abd66013e3693baac2db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "249b0ce12a5db4c8959c76ccddcc4ece523d6995e2a6fb39cae9c6f516afe7ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a4338fe9d0f25a6e7cbe45b96827a74e60555c055d073678953f8352f93543e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d02ee6ee903676222fc3b0c20dd56a97d9e0e8fbd1009d3420ccfd707534e0eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "824a21d1a86fd0789b284501e000531c5b724603f5941a61cd8085363087ef1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1c356c928fd2fdd9662a086d287de42f5a4cc85cb498920a160537de70d8dfd"
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
