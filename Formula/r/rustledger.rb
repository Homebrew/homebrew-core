class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://github.com/rustledger/rustledger/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "9bf9eed242b88e0997363cf24db3d0865e867074d34b194d3c2411629cfe0c37"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdf02bad3ebb3f43ca5160cc458d8a7e955dd459652daea1d9d5ba2c3caa8084"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f7eb3d9338dca98907f5a38318dc8386ccb881b38b2d728bc830bd8d6b94849"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09bb3826871a897f5179c91528838ee5d40880b33a72177595efb8f81be9dce3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff4dd67a6951c06e0cf103f04d7e8a3e4592ac2089d7ae42fe68c566599fa106"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "133efd3fa008f3df7afe0320cbfbee433c20235aa68bb5d160c862770cba635f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba4e6882c2baf098a0a6429e0edcbe80423400cef174d439caba1d915d4fea68"
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
