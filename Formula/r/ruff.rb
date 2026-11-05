class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.17.4.tar.gz"
  sha256 "a466d837b406c888f4f76e4be808658f36846288aa87f81ac89afcf078ad386a"
  license "MIT"
  compatibility_version 1
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "947f72d243e360cab8ee08e36900bb03513a10084076c9d7aed4c3507349cd21"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2b29148b3e398cd826ff21932c9da36d3a4ce8a38dd2d81dcaa3a565715d3232"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "10736ee0f483294f489ba05370b3a245d4bbb66f9eacf566e6330cf5c6a5e2ad"
    sha256 cellar: :any,                 arm64_linux:       "01e7fd02db4489a5916fd8eae6eb26662b74587da88193d674c4f6a7e2f30a00"
    sha256 cellar: :any,                 x86_64_linux:      "56f2a228eb01bccbe229dc1233a6713bfdbb97a9ca79d8982ea83d6b4e43a1a8"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
