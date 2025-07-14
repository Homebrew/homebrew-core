class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.12.3.tar.gz"
  sha256 "69995d2d58a2ce8324ea057c02183512ec71eb5c68861e33bdcecc1f38df3700"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a08011dfeef3ca2c3f5e988ba08267c2d8a10025eaed35d47584f2eea142ca5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32dcac93800d85f8d8fad1e6e45f08ff11170c82758ef2e4b67f5b9d9acabd17"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "64288a42f7706b551d0d85c8aebc55ccf8f01183bbe0b3f6540a97df331ef997"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cd8f87ae5c457ec01cf3f899b3a330f001dae445a6e5a357b96173449fc3f9a"
    sha256 cellar: :any_skip_relocation, ventura:       "febc762d97c400ba3b01e154f7fa3077b81efc21848f46b309772bcef55ef64c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "baa6231456491d464b6d806899cd7a21ecfaf1d8880e59f2ad71c3578d655019"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4749691b896e1552400ca9c67b4011b891c978ff7b4efc7cf7a1a57dd6f505c5"
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
