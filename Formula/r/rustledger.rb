class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://github.com/rustledger/rustledger/archive/refs/tags/v0.8.8.tar.gz"
  sha256 "3312b7ecab442844849ed0d618af1e21fc596ee0dd2d024925cc365335e6ea41"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "rust" => :build

  def install
    # Build all binaries from the rustledger crate
    system "cargo", "install", *std_cargo_args(path: "crates/rustledger")

    # Build the LSP server
    system "cargo", "install", *std_cargo_args(path: "crates/rustledger-lsp")

    # Generate shell completions
    generate_completions_from_executable(bin/"rledger", "completions")
  end

  test do
    # Test version output
    assert_match version.to_s, shell_output("#{bin}/rledger --version")

    # Test basic ledger validation
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

    # Validate the ledger with rledger
    system bin/"rledger", "check", testpath/"test.beancount"

    # Test bean-check compatibility binary
    system bin/"bean-check", testpath/"test.beancount"

    # Test query functionality
    output = shell_output("#{bin}/rledger query #{testpath/"test.beancount"} \"SELECT account, sum(position)\"")
    assert_match "Assets:Bank:Checking", output
  end
end
