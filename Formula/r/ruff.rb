class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.15.11.tar.gz"
  sha256 "1dabebd9346e9d913f00b7513a16bf3c82e72122ae035b5e6de7bff14c63eb9f"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3845c4375e99b2aec51d42dde10c7e6d9a7dc6083daec7ce2ac36d5fe626741"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a2eb76df0c5263847257002b972fa49ba7eab158b5c1cda6b71588dd227d742"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de3aeb961a96796c87d82d7142ba4166296b8b936397c85347e91a2d98aa5949"
    sha256 cellar: :any_skip_relocation, sonoma:        "8830f1b8ba1ab25206ee2879625ae839e9d1652331c8c6f00c4462d2c800824c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "761ba918107d94d3d3075b325b40bf2bf9d0a5bfc4e3bfda4a2127cd43afd341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7872a8ae18b93c3f947594139e388f794c1af24ca71bebc0da5f5445326a73a4"
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
