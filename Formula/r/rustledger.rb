class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://github.com/rustledger/rustledger/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "0e352526d2b33497b9f13df0237fca33a8ec0b6dd72ae4297c330a496efc80a2"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42f99d5ec7572b09a18fe931fd1556d213732f9e422f022abf4ba3429d11fea4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1cadea3f4bc81492c1722e7d7a22540a68feaa17cc37e217e048ed2a7b2895f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6245d4e08962ac539102c2772796f070db808c2087f984e8b475d6da988b476b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e7ae01b71276dc985fcfa955e851c55222f3dd9557b500795664bc924eeb91e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14b70802834e49a8beda394f64107dca611f33e260b7ab762f8065bb981464cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5808d5851b2efa3ddc22f994f4ba1c3d3d7d6c0d11429409962a37732ba0d58"
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

    output = shell_output("#{bin}/rledger query #{testpath/"test.beancount"} \"SELECT account, sum(position)\"")
    assert_match "Assets:Bank:Checking", output
  end
end
