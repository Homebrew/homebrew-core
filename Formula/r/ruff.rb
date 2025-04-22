class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.11.6.tar.gz"
  sha256 "cfb7b1fa9891c6d3c3c3e6b6d0a178384f3bf437d81a06d7d91592bd47846123"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f24143a2f2b315af5a0b0abdc7ba03f6fcc4400aaebb5fa329652cc830a1c3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f16e6163761c0bd5329b77a83ebdaaea04016eebf474154e341e3a23d838803"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e831ba5a0ba0c7b0c54bb887239d4e6b3b1c9595994577e93fbfc5ea7e6c93fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "8dbae960d5f64b1ebf8ade41c4e8676423731a130d153e1791cbdb854aabba6a"
    sha256 cellar: :any_skip_relocation, ventura:       "f4bd2ac68bfa74c68714e0be0b9a0717669c0f11f12d94bd51554dcce656f7fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d2d4ae9b7c440a68965f569b36d365a79f13b2bf66cf24d921e344ff70a29e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b119afae763fc01aff9ff823adaf75ff086f1bf8ca09f4060bfb11d62a6926cc"
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
