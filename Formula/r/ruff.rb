class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.9.10.tar.gz"
  sha256 "2465e4085d54293e3a0474309dacf1cc41e3ef7063fd7d23d886674141b08ed2"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "894f3768d5630d1747a91b7446826bd5d72a093924a3749d0e23f6e9ff426ea3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1c9e20c3ceaa541fad31dd8adc5693ad55aa3aee5d0cc0d713243e91d006e9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ba7dfd61ac76e8ce3c5017aa28838af863b449b091abdb082ca0557ec69149e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f913ec46355a55548642fe1d1fb6aa864ef3abef53b88009f800b5099e2dc7d"
    sha256 cellar: :any_skip_relocation, ventura:       "25b8dccf80562a1eeb12f9bae65f65bc9df8a9151ad803194f383fbf8309509f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "980268a9825ce096366032ec5bd8d151f037d11effd5f6bbc061b97d31777224"
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
