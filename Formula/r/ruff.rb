class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.13.3.tar.gz"
  sha256 "a9b65a8270dfd2d3d5009a94775227c1be1b13bab6110950681eb648a7de2512"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37b7ce4a07cf1061fae8e3313e17065ef09c804dcdd1c648fabe2617fe05c557"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7743a0eb23280cadc0948964c1b9dce481e120d352f03ab83af6eb2fa168b08c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbaec8f1ed179a100f45d4819ed0175fc2dc9270089ca8d5f64813d1031a43ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "c33b8b6caa8ea702d41d9d84b19cddf78f919d7858d3e67785bbc9d993450ada"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a77e6c35827fc320e92781b52399a6e90a0105e7b3101c66a4c61cd97951f19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6eacf8a06e51f0035a97912ab51079918c061014ea819fadfa8cf3b0ad601589"
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
