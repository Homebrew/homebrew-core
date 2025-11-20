class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.14.5.tar.gz"
  sha256 "62b63458dd44cbb723de34d3f0f3c03e6c7f55094a9308e547c4facdb7baa7ec"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b537d7d30f08c858a58e205f8cdfac31850c7856db38ab8c06dbbdb14595935d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1291219bd821c27db8f406bb339ba79c313b93a512a8ee5ca4fd279482e2c19a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3758b71324c5c887cc22a203cd6ef903567051c8921e595476ea7a8a7e55448a"
    sha256 cellar: :any_skip_relocation, sonoma:        "464fade5889a8cc2caabd561e10efbc5350d3947b8dcb1afaf77eb5a5a4ad3a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9edb232e1b6e70ab0dde7ac0b201b7d0d98abb5b5caba3f3c241e85aae2c5b81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b139f17b32b5e87623744c31efa54d4250e6fa9782c00996461138d5e8f5a369"
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
