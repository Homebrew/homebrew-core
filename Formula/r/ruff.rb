class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.9.2.tar.gz"
  sha256 "d47a61bbbfceda23ddd29dd0c3cb3bb55f240e80a7aa0ba944e7f9f3f6ed886f"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "321c76ee1af004603781e3951d08d7e62a2db45b49295c573cb691a76cce25c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a67231d0bc50934884870877c36f0cde87b85dfad8d8cd078a2c392edf9789e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e4956d710e60d7f82a31a75ea6784572fed492f885038ab2eafbe46f2588fd1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ea9257ada89fbf9b1ad07bde315a67a00c749f2e4c90c5ea15def860e4ebfc8"
    sha256 cellar: :any_skip_relocation, ventura:       "77ead1ab9d917489c539760165cc82178cb96dabb44b206030dbcdde35a17756"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4af1c57c2c7d885ebb8e33551e5b1ff4fbb75d1ba8cd64de97b5a54061d2970"
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
