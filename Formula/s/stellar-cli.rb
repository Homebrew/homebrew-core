class StellarCli < Formula
  desc "Stellar command-line tool for interacting with the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://github.com/stellar/stellar-cli/archive/refs/tags/v21.3.0.tar.gz"
  sha256 "3bbd1eba92ca5f6dd451a8606520b40cc71e2796b0efa32303c52a7901a2a944"
  license "Apache-2.0"
  head "https://github.com/stellar/stellar-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "105c018012f9137890b85f17783c2c4537e54b6563b792758c75e6a4eb094c8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92e066d06ecf3c190e8ffa5f79e03b3b8b7e4c9eed1f7ad4249baf568256fde3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5af37aeb8b10ea48362a1b352eea3329b5fd5974d87b64d0e6095933adfe05d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ec5f0fdb252307d2b6adf3dcd79970c0d0c3e153be7da1a4818836c9b60e9e8"
    sha256 cellar: :any_skip_relocation, ventura:        "d1e60cc168fe7d449f9416d0be96c5435ff1ff8466c4037e199b583b243a5b6d"
    sha256 cellar: :any_skip_relocation, monterey:       "e25fdad5c98e8e491e6d6e2896c89e4ca5452d9daccabc2d2f6d864051a523eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a882f04d0310c6568056574d08c0ae9a81c6231d7cf2a0d0deeebc44b04936ae"
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
