class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://github.com/stellar/stellar-cli/archive/refs/tags/v25.1.0.tar.gz"
  sha256 "ebdd40a0bee66185964f8e41e436e567709e101b7b26b6e4ea5a2a5860a900e3"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca88988ccb6575e737f996f1d7408caf9d834d9238abf9188fe1500bda2df749"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8287c8cb2557a7f8ee25914014a5a510e0644717aa187c1535d3af58d201d44a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a61f3dd5cc73ce9a1532e03aba4ddff480d98e15d80802e7c53e23fff41abe30"
    sha256 cellar: :any_skip_relocation, sonoma:        "51368477401870cdf730749d90610af06ebfc58461421551d8199cdc286ea8d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9b7419736e49c812e69b2f64c08de8948c12aa835626eebd1d7957160a581fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fd0e2b5a0d80f494e382ad5d33fb9104ad584c0e3a963acb852ff8e3e857e10"
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
