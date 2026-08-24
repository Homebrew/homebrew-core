class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://static.crates.io/crates/stellar-cli/stellar-cli-27.1.0.crate"
  sha256 "23f108265af26274fe004d199cc438777ca49b6dbf02157d4cd280e492bb1a9c"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e710bbab3cb3169e95de569cfd7bb16756dbfd7368fa02da59e666538b2a7fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd007ab19f1e2cf04b015b19377a6b2dde16150901b21c77c4a37348ff30dfc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "570708131ee3ee6bedc275e3c146251a7904a815cbe0b99fbfbb17b56e95b24b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2311fb0a68f703078d7b5121c24662fa8e4d21d8f3b6a670ef01d54dc36c8a63"
    sha256 cellar: :any,                 arm64_linux:   "627ad2226962baff2830a03b87d021cf573fddbf13ea0135662fe0ac782cb9a9"
    sha256 cellar: :any,                 x86_64_linux:  "3a7929f6cbddf20e3fb667ff89826b3ec79d92a47485d0525b7189335a68dac8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
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
