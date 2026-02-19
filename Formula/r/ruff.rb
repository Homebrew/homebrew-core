class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.15.1.tar.gz"
  sha256 "bb29d8ec29910f7e15c88aac676e875842ce0e56540bef2b93c9fd7ebaab78e3"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2e72ef103edcc44ca88671d72a9724184eea54b47cb8e575d060828b1ff73857"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "205e8e0c5a76d16b2986fc33c66dd53e1e24133a6b17f0c1784a1b7f21bdad72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b894cd4d3abd6668355292595629b56d4246c17c16cbc9070274757121dacd05"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f369c45f1ca3731cc07360f90cda0eae9f788241482b1c317a1db887f4622ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0ec36c3dcf2bd339dbdbd18c3069fa5752e06d3c6f9ba05ebafe14b010749db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d02c64b38c7bd94b89488307bda562561654b9ef8a8d09f9a03d0be537aebc5"
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
