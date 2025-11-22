class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.14.6.tar.gz"
  sha256 "58ebb8ec4479e8b307c5364fcf562f94d1debf65a0f9821c153f2b3aa019243c"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "958e625974156c3aefed2bcc370eae53f74182d3941a23560246f74afdb8afce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e84975c0db99086907128f25f1327f2538ff846b54017e412625003680b8e99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f409149a2ace4d597ad8a71031d66ac359df55a1aeafa61aa4c7bf90ce72b4e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "085f644447f4f609bb4391288f309b5945db32d8671cc044836261c1421fac03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "660f52cf381e1805d4b8e6f8f529b7dc7b446fd1e4742a4db774f1294c2a3c8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f68d38a25524392d99771f89bdc933442d4cddf3556d325f1f56c8355f564d4"
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
