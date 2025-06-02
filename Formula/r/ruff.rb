class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.11.12.tar.gz"
  sha256 "2ad90f833e177c3a0e81c0e3814e8b6571f0bc74dbdf7dc368ffcf6201ff142e"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a87dd795380749394d069bf87be4b392178d6754ad84f66cea7d0f24ec192b28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff4015336635fe4ac56f5ed7ca1bcc951390ba3a2d0265c74a8893349329a960"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec6fec0bdac214af90c3ea96796561c729f2002b70922d94d4f8503148a27f59"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa7976226114381f4e1792a415a8f1346d30fbbcc72cf3050966596278578d2c"
    sha256 cellar: :any_skip_relocation, ventura:       "ec5f3cf4ffd54944d762e507c7a7400ff154bcc3157b493f962de721645371c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2faafbe8bc3106a63381458053b1600c9a3d82b8dcf9fb0b0d38d9b18a149bf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91d56afe2541929b4cdedd6de22e1d1f9cea0a58c165f92b73b02f7ac31d2578"
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
