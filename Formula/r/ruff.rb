class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.14.13.tar.gz"
  sha256 "62b4de6effc35e37b3788cf87aa4b03d261da3da4cee8d9010839cfed2651be1"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2d2278279aa0b5b15a6280bad101ceb2bc8d16ffd81624a349589400eadf258"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0597aea2ea6ec55804a4884f730cfc00406309f7349525f4d4bf5da974c84497"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9aed0810a1edc2b98468fc068d592ae5972ce4b34c4ea3216081e37a0dc94c2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a492da3674a942cddd3891adaf884ebc4310f01f9281d4eeaeb96d539ed42caf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "254a6853a4f3d60c8b33e9d5b375b0ecc81bb28c39940fe2fd414188780cc975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f05d82b2268b3fe6e5bb63bf14c33a2c52438464fc11d88f0a6b6492b2af4365"
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
