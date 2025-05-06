class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.11.8.tar.gz"
  sha256 "5513715a202b2dd2516ebb67142d9ea8e52fdd73595dda3eb957804013d33090"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7288cfac1d25acf6f5f63137f8779014a74e20b13f1968c563bf1df52f313324"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "249746d73f949184186be89f62eeb9a7795d32cba4fb8252e14330e6478eb27a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "760ac58784f9d94536ceeeec9773418a31bd553968c2557a8f961ff7538a6bbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b7efb1255f533fc8f6453cd1ec053a7b863ed13ce9b22084824411c013b703c"
    sha256 cellar: :any_skip_relocation, ventura:       "1cb09f9dc9501ad92c87074a310d3fa4b524caa491df128d0527f68805a71872"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef6181166d511e4f023434d1ce3efe185d7e0181b8fc7bc0547a82c9f477e76e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ca5651be023a79eddae0ca16c859d18d2d477306e00bd8c9b1c9b709349254c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      import os
    PYTHON

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff check #{testpath}/test.py", 1)
  end
end
