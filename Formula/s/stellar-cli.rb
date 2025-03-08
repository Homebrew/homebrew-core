class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  stable do
    url "https://github.com/stellar/stellar-cli/archive/refs/tags/v22.4.0.tar.gz"
    sha256 "8164f52beb3a1f94b2eb9a20ca9dae495378bc87ca061c9654fb349f10d02a28"

    # version patch
    patch do
      url "https://github.com/stellar/stellar-cli/commit/e629c6255edb8ce94ab181fd906469cb33631c80.patch?full_index=1"
      sha256 "9da8629065530143e9e9583565a96c3f204bbb884992604a97a06cdd40ceb5b1"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b20f502bd4172793d82fc4d54337f2dcfed350a31758cd8e25858593af5d28c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dcbfdc1c905889aa961c0bd1970455438bfcee6cc08a1254bf127198b47eb5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3bd33995e6eed202679a5d07db289db85be622e389790b68045963a44fe1b71"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c052d7e27beb9001bae914bb2479abf773a3fd9b675530950f6eb124d00bf22"
    sha256 cellar: :any_skip_relocation, ventura:       "e04f51f45f61145a5a2eb592b36e2655375ee17429249099cc30339cc77734ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afd0e787133539f769ffaa7a6adab9949a7d600320cb6e3686d29e2f35b00b50"
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
