class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://github.com/rustledger/rustledger/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "b9e1289a32aa4f21064a54f8d2fbbc2011b93dc32e5dda5c91f5ffbdf1e00e7b"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3721fe47964dd533229fe15cabb7fd202dd779e2289be8ff845b504ae05f979a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02e1615620285b37657efcaacaa67e5daeec04861635907b2bf99361cb8070ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "551cdbd7b4df447f5034dbacfb3b16fde8820ad5ecfe02d4e66aa81248b9da86"
    sha256 cellar: :any_skip_relocation, sonoma:        "f83a882d77859c8943ad3aa982d74d349f0f3a96cb871653379970a23d7e27b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "421ace1864d34ad7ec3d812587dedc296e4b076c25eac7b22eb6cf078516f803"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28a0557322e3aced63781f4a69ac1747e80b0c40d28822cc0335708b4dcc8ec9"
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
