class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://static.crates.io/crates/stellar-cli/stellar-cli-27.0.0.crate"
  sha256 "423ca5c5317270e299719988463e2c3b9296ade8b9da06e3b5ddad09c64b5c72"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cce17f1f9f57e001975a808f47462d54c7565df1d91dd99fcc38b2850f7df13f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c100114e5478014815e10b21608f2e5e7cb617dcd6523a82414236066638d4d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c85e38f5281bdeb5bc2e05fd3c66ef3beed272f8e3a1fdef2c170f5a6a4b034"
    sha256 cellar: :any_skip_relocation, sonoma:        "c368f02fdb939b2b481ad5120be6381bb038e4c2c71e320ff27cbdb6484db1f5"
    sha256 cellar: :any,                 arm64_linux:   "41ef730559212d3ccb3f20902807f2858152e11771a160912c0d348399cebc96"
    sha256 cellar: :any,                 x86_64_linux:  "44ae58ef94a73fe9adefa081ce8dcb0d79ba7f0d317dfa9548e0f404d068e156"
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
