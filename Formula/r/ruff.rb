class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.6.1.tar.gz"
  sha256 "230a4ca5b172ae0632afb310ee7792eec6913eefa790423790862f0d91889ad1"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c77ee01db9666842f34eafaa66e08c587af364640efb33f35f62068341005fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d9fde69b52e15591e7fed05f8e9c6b08012df091eb241a2aad3e3ed312bf2b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bc35b22b1e905cd7d4b569861f1412429992767e60bd34a67280df042fddccf"
    sha256 cellar: :any_skip_relocation, sonoma:         "03ac9d63ffdec0f032314a0e3cd0103796c018869285ab5fb2da424e7416c293"
    sha256 cellar: :any_skip_relocation, ventura:        "3dc6dfd84c22988d6f7e063c358d4c3edc30cf35042260dd170477a1ec2c8be0"
    sha256 cellar: :any_skip_relocation, monterey:       "7015204382820218e57a77dea99dec8d183b3429d9901bedbff93f05c4cc1637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7aac454ff826c26f6806435b8a45b99447591250f425d1bcdd2a938c06f8d16"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff check #{testpath}/test.py", 1)
  end
end
