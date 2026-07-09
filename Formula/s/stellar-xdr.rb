class StellarXdr < Formula
  desc "Stellar command-line tool for encoding/decoding XDR for the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://static.crates.io/crates/stellar-xdr/stellar-xdr-27.0.0.crate"
  sha256 "05ff843326969bdf1ef673dcdba94c08f4a3c8f1e58d6e6ef39b1bd4f749179a"
  license "Apache-2.0"
  head "https://github.com/stellar/rs-stellar-xdr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1270e918bef555c55e93969d1094185d218dcdcd4b473e3529cf301ba8b898b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4482d1042aef02d6697f0af1306ec15a2fe3aeb9dab40351a6a3029b2ed0aa33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a7f2e6ebcf2ad6c69a7ee43eb0525f5513e5d0d527590a629a3ca7b80a95979"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdf5b3c9e96e7f9d954cfd809d8fab216234c717169998bfb20dd63c6c326464"
    sha256 cellar: :any,                 arm64_linux:   "3f65a7b4d73864c6f6d5359c3ae37d69869fd24dbe95c28d9e6eba2c4faa4a68"
    sha256 cellar: :any,                 x86_64_linux:  "03101617fdbb68a7730bca02a083838925b1b49f6038ca716694207fe8db256e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(features: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stellar-xdr version")
    input = "AAAAAAADJH/////9AAAAAA=="
    expected = '{"fee_charged":"205951","result":"tx_too_late","ext":"v0"}'
    assert_match expected, pipe_output("#{bin}/stellar-xdr decode --type TransactionResult", input, 0)
  end
end
