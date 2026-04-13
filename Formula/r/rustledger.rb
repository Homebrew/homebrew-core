class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://github.com/rustledger/rustledger/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "b130e149a39c0e79a072346cc80054a06d7987425c86a23d7fa45cbd8424d697"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ccd8eaf72023d9a744a80e0638ce018128bdf930ed7ba0e94e1f985bdc6fffd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56b33b169573067bd7dae9272f2e38f58bb3305a53016e0245e2940790fcca06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1c860feabf4b5e8accbbf487c9c96342577c4812ceb259d4ed67ddf31f6ca39"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3e5a00b98a3f2c34e2c6676e4f6833efed0366230c50a80a6ed6350136d2b36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbeeb75776935771bd6da1b331e1e2e4529dfac719220b73bc90d64e7b1d1bcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d6182b7dc198bf4b23015babb9526d738a10711a5fdeb88d77c05606f222c57"
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
