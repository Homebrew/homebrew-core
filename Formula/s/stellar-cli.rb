class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://github.com/stellar/stellar-cli/archive/refs/tags/v22.8.2.tar.gz"
  sha256 "5f93004c8768cadbfd4e5f30c7566ea6d8a9dd4066e810dba75886cd79115a10"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55d8717a14eabc8edacd65f2996cfb8db3e83f2651691da41268f53b073f8482"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30b68e7205f54c28032a60a6e11299bd7d75b0a3fe8b8dffd69577b4f7f39844"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a58b98cec47c16bfdc4d204a4c4ef005c19642aa68f69047cc26a92c0883a29"
    sha256 cellar: :any_skip_relocation, sonoma:        "3165936b51614102678218b447766db817b06dc9a0b5c0e2372dc151fc1ff998"
    sha256 cellar: :any_skip_relocation, ventura:       "cdd11a47649e2531aa2fd51cdc153296fbc37281b7f81b457f6edf9a74e70080"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "145f4c60653a9422379a8542e8395ae3144768545a834fa606e279d416824816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7daa467796a6622f6b42e39464233522aa756a524620f4d279e1b8e68d38fe3"
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
