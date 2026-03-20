class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://github.com/stellar/stellar-cli/archive/refs/tags/v25.2.0.tar.gz"
  sha256 "1fb292367927b4d06a6fa0eeb8546066eb53f51fd838f6037c941bd0b70187fe"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "587fec478e377cd418f9d8f25552b70318e0f72eb27305a796a4eee94d13f164"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de9b285cea2c11a3a18d2076b8e04af3d0e0ace4f1490dc8a459185b5d1971cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f01d11a8917535cba2addeb6bb62aff4f0457ae8e549aa2182345770cb81d0de"
    sha256 cellar: :any_skip_relocation, sonoma:        "02352140e9c281763730a0d561c226946b4d5d4a94fa53317055dc4bc35f552a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfb605020c9dfc8f06209843799060abd061414a2e7b8556e471a77875180eaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "954a0f587dfdb2b9716032bcaf5cc4ab9a8914496798561b65b6824689754f89"
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
