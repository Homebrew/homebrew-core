class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.15.16.tar.gz"
  sha256 "69a14a3099e6e5b0e92403713bf9e2de045fca2708c75d9ea64565b4f68e6d05"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "593568c5cfab81719b639a47a313cfb92033c5abc4067f4994cd395e0a5172ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aaa7566fd0a9eddb16840e8eff52b734387eef1dc16e46df9f488fc08a0f59fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa828d6b311506a07cb2ec0d476031d27124e03cc512e793f06fcf46cce23f94"
    sha256 cellar: :any_skip_relocation, sonoma:        "be4c0ca507137dc055094fbd8768730b5a56c5c49c8d5ce66c989e9a0cd67a4a"
    sha256 cellar: :any,                 arm64_linux:   "3c4ab8f915d46bc24cd79e77006e53add1792793c6f8123e97c70b0df099ca8e"
    sha256 cellar: :any,                 x86_64_linux:  "6e1d318c481640272a8e36c29882e89eeb60e28d4dfc7cd07554cff785571f99"
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
