class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.15.20.tar.gz"
  sha256 "3d2d9283f8221d04f1debf1ac32ec900bba08aec5609266ac93b8b8464073d16"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d18974577d96aaf0fbd16297d6d7dc213efb38af1728331c52a36240f5efcd85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a37bc28e03a7ef44178e6c9a9ee66472728edeb7d75eea58332d475035410949"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27247354fe247dbd1608608e70a2e60bd6a9dfeca8064a09743ad2d46a5e06be"
    sha256 cellar: :any_skip_relocation, sonoma:        "e68e0937d132f5bc08d3dca04b7f69f94a613b1e5bb192caab9d50b858170036"
    sha256 cellar: :any,                 arm64_linux:   "0ae86d165a08efbcb76c681306e5ceb28144aca8b5f73ac3ee189096ecae3a1a"
    sha256 cellar: :any,                 x86_64_linux:  "d5b434d30445a68809f4545a0a090623e474065dfa3583299bd89c164f99ef46"
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
