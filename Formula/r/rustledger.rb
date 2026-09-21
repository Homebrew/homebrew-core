class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://github.com/rustledger/rustledger/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "0624377cf985722ae367747d586931e746a4c7c09bb962474cf73320d6e5d1ff"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "287059acd34fa77c273cee93ee75feba15971b8fd5f4ec7bdb6558d983f3403f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fbf41449d4c19c284b9ed9563b8ff15d354c845687d9014212ac55c9051805c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e6fe3f56942efce0cbdab8eed26cc1aacffc1adabb3226bc6a9ed8115bdc0b8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "7d78c2062cbe66136dd97c8a87fca29ecc02ec7775dc33e7232da27500c760dd"
    sha256 cellar: :any,                 arm64_linux:       "f6c94a5f90da5e657d6b29c85e9304109754e263d08a76b4703c224c2480a264"
    sha256 cellar: :any,                 x86_64_linux:      "d28bc29f428de15419451df9b4eafe602f1729f31cef1904a885d8b16a5d3fd4"
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
