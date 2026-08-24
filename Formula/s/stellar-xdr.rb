class StellarXdr < Formula
  desc "Stellar command-line tool for encoding/decoding XDR for the Stellar network"
  homepage "https://developers.stellar.org"
  url "https://static.crates.io/crates/stellar-xdr/stellar-xdr-28.0.0.crate"
  sha256 "f93d09ff8b9f919b084f664003c4c546ac66a76affd5429460dbe29f4b326f8e"
  license "Apache-2.0"
  head "https://github.com/stellar/rs-stellar-xdr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12a145eab1f18733f4ee40c956958630948a07f3ffb62e194704b838c5061ff3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "033e0dbed90219741ce2377a892787ab0b9bf9d79be7e6d19b538dff44c73521"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a41396a2a48c01cd26f0be33adba5b14cc278a15e62991327d18722070a4da91"
    sha256 cellar: :any_skip_relocation, sonoma:        "37ed4eb3ad936f0e1050577e410c76e8813d8ae1d3aef60572472a2b074069f3"
    sha256 cellar: :any,                 arm64_linux:   "63e8b2fa5fd95d102af68d1dc929ef2adc3168c3d4e63e43f00de140353d8112"
    sha256 cellar: :any,                 x86_64_linux:  "895952e4875cbe537553a63a32cd2de4461307ec446689d8d800154927830b0c"
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
