class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.13.2.tar.gz"
  sha256 "008287603094fd8ddb98bcc7dec91300a7067f1967d6e757758f3da0a83fbb5c"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01d53ad092fa525688eb016b4f4c232fba7600dcabeef5e01d9db093b7730dc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "121cad7e51f9beda892f7b2889ca57c2ccf93a9e4af9c5653ae5d2bb5658513a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4563861c2b89ff248191baac4ad3cbde6a8b0d9fe7e3dd3ae210a39ea468d97"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6960a4e768b18cc87baa99bc0897235b83c3929e7dd340aa1b22e8996d7f0ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f97cbed3fc5849dd4f8ea84390d1125faac57a6b9a6f2243f362d94b6935253d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e43599df01152860cd9d6faeb6a2ae91eb0dab586b9367349d3cf33108c7815f"
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
