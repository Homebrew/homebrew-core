class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://github.com/stellar/stellar-cli/archive/refs/tags/v23.1.4.tar.gz"
  sha256 "37ebab203e11aee47e9d0de206667b294cf20309e6c547d6905fa3907f2728f3"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b64329e1c30089c71d7c7bb5e4070ed99c4439c821662e85c980f2e77f77b155"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e0b82f9fb0b74469c42610118dad622c6f56cf0508c1fd6b1d03c059ca61eef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1c25aed977f39ab39bff6e0bfef7a179376ce574a21066d2e48ea16e0034da8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a3922fdd383daa768f08fa1560dc1ad92a9dedae3e830384d3f5b2004d81c6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0a6c6faff3416304d9fe6be6478b6dd2d9f689b26574e504254ed0bf765b0d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90d4abe29b610bb41a8d0f0d2540c837055b1150dce56a0a02c23144ef6b2b00"
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
