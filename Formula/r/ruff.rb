class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.15.12.tar.gz"
  sha256 "368b5af4b9373123a58d3e8cf702ab5584dd359c9bfeaec8f08fa2a1b27bea93"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26746799455579200608e3b07f1cb3fb7de21ea431929228176d73e9f815bb26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b42cd39567683e5b1ae1f6c8d21a5c8b7d38f8f04a638b6d570d942659bc4f1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1aea821b1b03aa279d40ebfb27788bc13f6afceccdccec070477fa88e58afd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "b20b101fb4b440e402c55b3cf6a9aeac5a3d0305dbae61c6ed6ea9d9621117e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e65730fa28f5c7625a3785ca9d4ce96d40a9bdda4d6625e9ee68db57659e26b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b75cc6d746f926343ea67444ab09c6b8a501a414370ddeb7461e6d1c7baa88fe"
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
