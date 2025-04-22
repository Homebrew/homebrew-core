class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://github.com/stellar/stellar-cli/archive/refs/tags/v22.6.0.tar.gz"
  sha256 "dfc76f8071f1c220dbce8434e151adafe3f89d4ae342c653a26e645328fc1bd4"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad5e6a82ee4d0f0ad80e7e5d16220126314435baa1ebab6ca8464b03b68f77f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4737b2bdd930e6acb87c2ec453a36d039e3359c8cf1bd4a088cdb467dfb143b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5bf0f7cb93b726cfaead6b8348f5ae7a764b196664eafef3668dc0f7633e52b"
    sha256 cellar: :any_skip_relocation, sonoma:        "902025829ccb8ca24d3e19e4b83783f26771b819b25a9126d4e3d740a70312b3"
    sha256 cellar: :any_skip_relocation, ventura:       "6a2fcba911e6cc1e7f43d9b5e9171ff4df48d1c45f25c604d3bce9791279eb63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be3c18f94bedc609ec28a6e4c79c5392c534d05ada640cc33a1e29acff040289"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a1a35b87b2eebbef82a9e47db6c52c627bee9ef9e5b069d1f41ad754d41f555"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "dbus"
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", "--bin=stellar", "--features=opt", *std_cargo_args(path: "cmd/stellar-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stellar version")
    assert_match "TransactionEnvelope", shell_output("#{bin}/stellar xdr types list")
  end
end
