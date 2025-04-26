class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.11.7.tar.gz"
  sha256 "ab59cebf7d263483968e9a36c9120bddfe0c0deb219160d1431b3b33631b88ea"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a37032571dd434bf9e5d8baadbc9e1e447445efdd7dd6ce5f14515c01926120"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3eea1deab5a057bee4354f338d3d653828664070d43809f801a64c2a3768dbb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6de4b9ecbeb4260c0cdc7421182db9fe7bf042c706f44b64c278c7922da74af1"
    sha256 cellar: :any_skip_relocation, sonoma:        "59bea8b08152a0eb4ddf01908f30396bd05d821b84dd2cdb193fcf740cbfc5d3"
    sha256 cellar: :any_skip_relocation, ventura:       "26f5954ebe1516989a5969edeb79ee8eea8f42ca0432e2717360156064e55d5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bf300f27f48f73e897d9b617b2dc471a6763302bfb9611de411e1f04807a071"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "872a612eaa5d86ac62002f818315e9d30536e3db475c81eef4283197d4cc17db"
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
