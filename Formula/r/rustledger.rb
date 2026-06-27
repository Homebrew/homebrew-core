class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://github.com/rustledger/rustledger/archive/refs/tags/v0.16.5.tar.gz"
  sha256 "68beaaee5cb11f622f60ed3ec97df33e819c358f1d815031b25c14483758f04c"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb21d26a736e312697d2337a1d4e9ea56896fcfd506b525f5e03eda0558ca400"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0904b09fcef544e03fdb29e3ee47d8ecb9a8917ed5cb074e35d75bb6a7b87a3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32784a93a8487e3434c98dbc8cc6d63e18dbd59d0cceba466c56a9196bc96b92"
    sha256 cellar: :any_skip_relocation, sonoma:        "3eb58f2ef0d51d2a26d17932090d3f3b0e6520118d28b4a2a1f8a1b01e1cf96b"
    sha256 cellar: :any,                 arm64_linux:   "093087704c6a5d670b77f8c94fe16d50ea6a8d4997137461015273f2597cecd2"
    sha256 cellar: :any,                 x86_64_linux:  "7fc98dd718c8ad0082732d6dbc1dc397e007d736fc5b015e14797c5654a407f6"
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
