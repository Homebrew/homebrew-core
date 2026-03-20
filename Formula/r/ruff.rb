class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.15.7.tar.gz"
  sha256 "370003574c8bde1eef286ece925f33e43be4d3564c8eca8dfb4fb100a1dce797"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf899ab597d7d446cd1c51828fd4371aefe6afdeda1bd3540cacb1a6a0e82299"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89962cf174c8d90dec742b575198db0655e7c1dafbd430518eadbef12fc3c5a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5266a8dd263e8387f71b81ea96ba1dad6e0b378638a339919998190b5e3a12c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f173270fc12d5efd42d9b3aac7534b90a4df737a42d50dbcf6898408fd5c8b87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8a7462124c19524cd181be156a481a68361545e9acbfa872703efc76accc600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77bcce1cd000a630944881e0fa77ceefc9f38e559f62a27ff14936c4cd3e91b8"
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
