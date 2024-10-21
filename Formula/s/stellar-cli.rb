class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://github.com/stellar/stellar-cli/archive/refs/tags/v21.5.3.tar.gz"
  sha256 "a30c7b5291558a0924d79924f6add2b5db0514ff67dabd71f5ecbb12a957d928"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00afb8e432b02c40a5fc9eda8e57e2f7ccfcafda50732914247308b1a2352f06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddc127ae0fe1a621375fbcd4f2f5f9f27d48544bdc19fe805ab9feca0ea5491a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "048894c60188076ec774c5e6807317322d4108b3372bb74db77b3dde0dc04619"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2ad54c6c2edbece073f9ee8e192f725d8397ba59ca7d0d7781ae63f20ba6bf1"
    sha256 cellar: :any_skip_relocation, ventura:       "52d16b202ad79fe8904427ca7f00b712c40f52f6f4b0ed98a6dea580873c417e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15491afefbac64e5e9794a18a52210f43f432a1f4ff4b05e2af07a224779fffc"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", "--bin=stellar", "--features=opt", *std_cargo_args(path: "cmd/stellar-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stellar version")
    assert_match "TransactionEnvelope", shell_output("#{bin}/stellar xdr types list")
  end
end
