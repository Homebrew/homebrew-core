class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://github.com/rustledger/rustledger/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "8cbac0fa8a6da0abfbf172469907068c5cc615af7cd0463b2cadb0081a0da733"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9b9c814636b823420583c67d51aa6c2f1714957e6034f01921380587c3f92dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0dfd7fc1e91994b1ca0fdc43794c3aee33ff68325609bb563708adf560c2c92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ef155f771acdba453256e00be4b14921bd2b13eb94bab4d5d25290849c0d5bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea98aaba0df9f1fa97f09074343a17dfe6377f6a71d4b8932a67cc765f0e51d4"
    sha256 cellar: :any,                 arm64_linux:   "c707e5836a039c736e0a25617dec8a22a9f119d3728a4197ba967e4be010d3c9"
    sha256 cellar: :any,                 x86_64_linux:  "8c47be9cd8964f0d5dbabb126930a84bca588f9d8f9d75690fe0d28e32c6733e"
  end

  depends_on "rust" => :build

  def install
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

    output = shell_output("#{bin}/rledger query #{testpath/"test.beancount"} \"SELECT account, sum(position)\"")
    assert_match "Assets:Bank:Checking", output
  end
end
