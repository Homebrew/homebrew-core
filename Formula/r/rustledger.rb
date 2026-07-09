class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://github.com/rustledger/rustledger/archive/refs/tags/v0.20.2.tar.gz"
  sha256 "830a0d1db7fc4fe4846c851340077d37ff994a54e3d7ba7f25ff21fccb2245c5"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19fc8ea0b73a9b3c047aecb8e162706fe843a104a1f814d5c8026e96e9f01f7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f8c3dcac624f8fe942cfc3d6b2f791e8b5fcefc968c24503512c4b695841e6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fed5d479290e2b740438142b114d171d26280a3222e9d82ebcac62217ea7f21"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f4af262863af9dca7e60b37cacfc8f1bc5ffbd59eb26ff133de557428498051"
    sha256 cellar: :any,                 arm64_linux:   "e4eb60235c09c644140fe5d12fb8639c904ce99e86cba523585eea3b73c74609"
    sha256 cellar: :any,                 x86_64_linux:  "21894ccb8b3292d5e341807e4b11f79afaaf391d4e5cea4b9d1a3dcb967895ee"
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
