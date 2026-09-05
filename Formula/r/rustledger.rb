class Rustledger < Formula
  desc "Fast, pure Rust implementation of Beancount double-entry accounting"
  homepage "https://rustledger.github.io"
  url "https://github.com/rustledger/rustledger/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "901f8091683c56f41e38728a3aa1df10dd1b5608f890650efa7e66364f7a5bc3"
  license "GPL-3.0-only"
  head "https://github.com/rustledger/rustledger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "884630e4ea5b419cdf14f5f26f1acea66683eee5338ac8ea1b1ba1617cf22901"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b52056bce3c6932cff7ba103269a48cae7f2f25e5ea641a4f42046bc28234aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a1fc9b67c39ff0fe9a7873801e8e2826e1f4508c7b7e33762a27892cf1336d4"
    sha256 cellar: :any,                 arm64_linux:   "46bc0906b1576682559ec63ad34ac97a80daded53ddfaf44372216fab6769546"
    sha256 cellar: :any,                 x86_64_linux:  "b8d3b52148155e1060af884609e0dfcc80916b4418b8b974f8339fb638a2d6e7"
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
