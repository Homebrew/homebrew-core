class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.8.4.tar.gz"
  sha256 "f48c9e2479e72957ce5dfd3d0cc9d27f5aeb36d15ae2f97c9c116fc5c742dc5d"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cce93a7dad976b7d65875eab156a697ac8eb24e08e75bf57115ddedc32c46c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13159c9ffbe6dc1095b1ad8a322fbe1c953bde89cbf774605ba3ccbdd3c69824"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c23214c06f7ddff3194ba288449dee7dfe55f3fb26956d7c63de8ae3cc36934"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a24c43c215a81945cc01e563f3955ffa56dae8d175bc8d99e7ab93a4c19c045"
    sha256 cellar: :any_skip_relocation, ventura:       "f7d3bd6f41795481bde6f37c77bdf667f1697fa8fb21569e40ff604419169561"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72c2d2811179191121009f54914144b7245516944522d6d279b87faf8b514df1"
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
