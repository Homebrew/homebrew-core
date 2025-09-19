class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.13.1.tar.gz"
  sha256 "a4652f77a30d8497b2da05d8e6bbb7729809e8d4c80c2d7b49febc0706444bf8"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0fa8563465e183b13faf3ad387166ea2978a8458d4cafee2d10cc7dd1ff25ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d50d02ee6759d5199f55834bdceb33e4e3edbad308b17b35ad5c55c1fb5f487"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "672a8cad7e7c9c3f2d0e7d8907987b85b79a6c3c826e7d67bbc1ca2a4b5fa6b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd0eaae6d2e50dadde28b3010ac58dde27085553e6f912fb187f51a21b026ac0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4beb6abe5e9da108b112f6ffe58d0b4730888fb723bdde46a56b489036ddb1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e7669daceac3ba0b00ad9a0ea840e44a27b74c4aae52d1764d93fe24987d28b"
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
