class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://github.com/rustledger/rustledger/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "0ba942111a6935b7d5c36672fbc2314d3548589b9efbb7a7742472394f03452d"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f97ed53c3a2255210bc916eca56ce011de76359d59694c5311d870a000a047e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a267a257291acb089ee86e29a33850ecc3fccaaa2e79554398fd7251cb4837e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45b710710ba5462d73f8dfbe7dc74d209cda84c0bf18a83200e7b899da781b99"
    sha256 cellar: :any_skip_relocation, sonoma:        "658624b51f2a20cbe1f2b9e353221f32780b76617836f45f34ac9704488502b1"
    sha256 cellar: :any,                 arm64_linux:   "173397884f70ce6e0ca4090dc3d6fbb43c84c478403b995dc8f547340460ca79"
    sha256 cellar: :any,                 x86_64_linux:  "26b4bb14b6bce2037e07ed4262e7627978d95226ff76f5ecd17984d8c14e0005"
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
