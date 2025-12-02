class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.14.7.tar.gz"
  sha256 "e137d712834274bb8faf60ecd3c6040b831c52330c3c884cb925b531057ea575"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5b628020bd802af07be51aa14eaeb687000f0b9e90e734cefe373fb1fac2386"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "891fb99385a0b32ed1810cea764387c74680e7bd6d1f314a8b3f9b72d3bc7a17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb3624ce1e4081b9f480d6ed3e652b87990e763786208bc238005e5798740068"
    sha256 cellar: :any_skip_relocation, sonoma:        "a71aabf51cab5fe3501a625c700007167c00e93a36e2e9e6fa5cc11bdb3b5cb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9305afbc47c9d8c0439416ada8f9bf3e01011d302f467438e0fcecbe75e0e5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca1a768c37b7e419d0aa187a2654735610e2e81314acf62e55e29cc345cdc9d0"
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
