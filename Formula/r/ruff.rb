class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.17.6.tar.gz"
  sha256 "2c7f6831696e0c8653829d8a6ceb02b97ec2d00673385a7931c52471a5fe30a0"
  license "MIT"
  compatibility_version 1
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    manifest_sha256 "0a2b8682f29966822adc9c160cabf9a6106aedba362094fbd575d5c2e54f98c3"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5618f0f7ba207f93d0a3acaefdadc4e02c097d41561db3b5b3329ab1c43cba0b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a6632a59ed774c340aa20d3dca3287d6adf58567f4bc557714ba38c133a9ab8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "017e0d193e3370b2fe3c0883d7a3f381e5c8a60b3b733c79be4007690b355ffd"
    sha256 cellar: :any,                 arm64_linux:       "2accade3531184dd8d2255ca3d5e0874e9f8e43475d77a85114542869eeba55f"
    sha256 cellar: :any,                 x86_64_linux:      "b0ca8c050d19047f31b77c65e6fdcf5180038033363b56cfa40fd68d517bbf15"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
