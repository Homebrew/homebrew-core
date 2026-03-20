class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://github.com/rustledger/rustledger/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "a70cf5d57da631fbb84f6ca4675cfcc4e076770a440f71ca5cc1d4755289f18d"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d67ba9710030d2d99959907beaab27b904dc59654adddb33d77302e15d06eb7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5591a4857706ad3866d55bc26a026f4d710025bd6cbe58fa32830c3149ac496"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34a02440ceb8bdcc6b5bc20c8fca8ec0c6214a9709d2735137b86f9ad429bfea"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf4090971741b3fff1ca4f1faf3a2d95a53fea9520425288dcdbf36409a5578a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "942f0399811340b46cec64bcb90a3df4faf85ca00c403e2f04e61b88d3dec021"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a972f1cc9dc02dc5cb034981cb94164325b68792ca01cd565e87add1bb9e022"
  end

  depends_on "rust" => :build

  def install
    ENV.append "RUSTFLAGS", "-C link-arg=-Wl,-ld_classic" if OS.mac?

    system "cargo", "install", *std_cargo_args(path: "crates/rustledger")
    system "cargo", "install", *std_cargo_args(path: "crates/rustledger-lsp")

    generate_completions_from_executable(bin/"rledger", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rledger --version")

    (testpath/"test.beancount").write <<~BEANCOUNT
      option "operating_currency" "USD"

      2024-01-01 open Assets:Bank:Checking USD
      2024-01-01 open Expenses:Food USD
      2024-01-01 open Equity:Opening-Balances USD

      2024-01-01 * "Opening Balance"
        Assets:Bank:Checking  1000.00 USD
        Equity:Opening-Balances

      2024-01-15 * "Grocery Store" "Weekly groceries"
        Expenses:Food  50.00 USD
        Assets:Bank:Checking
    BEANCOUNT

    system bin/"rledger", "check", testpath/"test.beancount"
    system bin/"bean-check", testpath/"test.beancount"

    output = shell_output("#{bin}/rledger query #{testpath/"test.beancount"} \"SELECT account, sum(position)\"")
    assert_match "Assets:Bank:Checking", output
  end
end
