class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "422b84742188a722684f0659c875a343065f9edb78350cc4ef63352e68c4339b"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7341012aa4cd68dad436fb694af64a9e5698835503274815b584eee1d190f96"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6054c859cbb98d19613ec119380d58548d176afa18602f7907ce5c572c39f27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6f7a4cbded87976619b25bce5122dc89532692bf9aa65b9fb4127ac90c4a683"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac58db172eb12f7ec1fbf6fdbe7305c0f94f03ea7a3930db2547907af1763f98"
    sha256 cellar: :any_skip_relocation, ventura:        "4eda2012be58a44d96623836e5a51df9482d32672fa34747859165c253d497b8"
    sha256 cellar: :any_skip_relocation, monterey:       "0ea37374372c450dd8eac446a451eb5a9f6b630135074fc1b781b1c67ebfa563"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32224d489deecd2d4ef4b34006c736e082528e78a7ab0020006e9404b36524ee"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff_cli")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end
