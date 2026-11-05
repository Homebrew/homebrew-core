class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.17.4.tar.gz"
  sha256 "a466d837b406c888f4f76e4be808658f36846288aa87f81ac89afcf078ad386a"
  license "MIT"
  compatibility_version 1
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "169ab3d15ad774ea3299ddd595ea32a3e2613bfbd1884dc36df975b38db49a22"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5e833ccdaddf26e0c1b6eca8733192e79ddb0433678f0c9a7c2f2d53f927f734"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "17b374b5142f14e7e4a50f696d44c8c3dc5886766d97874a365785cf397859e5"
    sha256 cellar: :any,                 arm64_linux:       "13b776de76daa4d15c21c599d1cc8c9bd41d5518df3a69799bde22f9e6d2f194"
    sha256 cellar: :any,                 x86_64_linux:      "098badf99a9226e76df4d05b6133237008b4b509ddb2ecd7324762d72e28a0a2"
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
