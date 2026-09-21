class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.16.8.tar.gz"
  sha256 "42f2b5af083151646886e7eddcf10ebfdfa89d4ba1a8146b82422497688921d3"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e646826ede864eb33117d19b7793b8866b8f5b4d4e0b5534be1148bf8a405f18"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f90870be939c86249c3c54061a263f7832ee507f124d7f263438f2d56d28db2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "20e85c46870ec754e9f596c27d5e6784818a3ffb893ed71caecea990bcc6afa7"
    sha256 cellar: :any,                 arm64_linux:       "5554f83593bd75be03d2134941e9c816d09fdb701e294e13079e203ec59890ab"
    sha256 cellar: :any,                 x86_64_linux:      "d5895dfc8f75a305ae2f1148ffbdcd3872c7b6ed03b52062c537437b199fb5bd"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

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
