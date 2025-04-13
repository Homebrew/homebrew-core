class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.11.5.tar.gz"
  sha256 "f4562ee021e2100ae4d54392ddd8af986254bf5d9e0351b2dd91947b2adc956b"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd3afef55a36052c232ff54efdc6aa197a4072d63c126a324a78ceb39e7f0184"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1313463e86cd738324cf79fdd6dc6e7711d3d802e69f128c54cf6391ec1a4c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c8fe32c599b77439714eb4187feb835a01b6ece9ef5ed4c7196338507709e85"
    sha256 cellar: :any_skip_relocation, sonoma:        "ece17212db6ffe20805120fb2398aeaae5939ba145a62c4a33560d66aed249e7"
    sha256 cellar: :any_skip_relocation, ventura:       "51903e9a5f7d11f21b265668506b0c8eb8a43c7c3f6e5970fdd065a90e9a8cc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b9b5adbbda00686127023b1cf128765053628550b4ffd7a11f600604e6877fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b9ca5b1f16393b5fba52f8ce482427fe19caffd98eaf123ff8f3ed8f878cd81"
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
