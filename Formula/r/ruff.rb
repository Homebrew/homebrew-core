class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.17.5.tar.gz"
  sha256 "3d920afb666d51ebec3c80ec2847ae7ad14cca3badaaf39f1c0a175d100a4506"
  license "MIT"
  compatibility_version 1
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "36964998ea8d000647fc63ce1c1c2bbe45dd669cedb234d808a41cf751bfb97b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bcd142f273284933767af015ebe3f6bacc8cdb399f56d75bb55047140cf52f1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "47582f43d09a8383e29826c5552735ca55a20db1507bc8ae8ef037c92055d0df"
    sha256 cellar: :any,                 arm64_linux:       "9ff4ee210a9583ef24d0cdca51868f5da58436a3bad0bb6c9b78213aa8415e43"
    sha256 cellar: :any,                 x86_64_linux:      "8d3b44f2d57b30d0de6d37625fa00e7b5be702e4366b3995dd05aee90aaf2881"
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
