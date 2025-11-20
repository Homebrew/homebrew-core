class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://github.com/stellar/stellar-cli/archive/refs/tags/v23.2.1.tar.gz"
  sha256 "2ae722e4433cd86f239c5f0fc437013f4649ed3a825e89139b83b050f1b58e04"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1143efdcb0f10605727bd885070ae4cd85360aa805dc6d26566eb9db667b5a7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef50a511c974b7451c65221a49e26eb2478cf640c5c3fe05d321a1ee36e800fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a5cd3c5bef6d54037334f4f92cffafb1ff3cf209043d61272c2dba31a081e63"
    sha256 cellar: :any_skip_relocation, sonoma:        "91d222d8f70f81e47ad3565a67734ea1b8091cf8e3d55d53691b056713b47314"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75f30c218ee21b5b7d4d79a092fd425e39bc080176372ed7f55efbdc02e04246"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6cc00dc2a0d4b8857de2488d0428dd281c5120b261d3a7771bb95c5ddf28748"
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
