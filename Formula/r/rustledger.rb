class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://github.com/rustledger/rustledger/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "e26b5395781852019a967c2b458529066d5da259fbbb67a545d63fb166d25671"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ade41757a17044cac747b4b57b681d7702b6942eb870c8c770d0ddb04981caf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b9b6b962b2ce2f576fd171ca3b2dc1733de5669224ba8535cd89afb1ec40cdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "867dd381e67274f365b09223181a5d3646a890954421a8c6885698795aaf53f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e7596d7e1357d7c961b2c543fc612f236d82d445fade73bcc95b89310dea32a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fddb6ed2b845240f23e109c0ac81be444f3914094b283bffbee53d6ba2d58a9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79047b0a2e8e838c31d55b78291a924c4216f48e382639a937cd7be611141722"
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
