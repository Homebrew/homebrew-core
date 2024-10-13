class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/0.6.9.tar.gz"
  sha256 "502811ee2607cb09e3e05f4c3d60ed164a5e5a24aeb87fe00200b8d508a0b0c4"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d48abdaf8d2d8e2e118b2fa473b2defb9c4ff060dd5201f94f7428ca8f921d6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4d8011a1b4536a3509481dee7da53552a30f81f12a67c072bc596a331f1128d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f67896eb86a9ba81b11bca9b42783c34b80d67935a72a948c8b8ff6aa95b0deb"
    sha256 cellar: :any_skip_relocation, sonoma:        "b11d1aa4fffa0290463d128683410477386d6f988cd484925e3c6a5954bfffba"
    sha256 cellar: :any_skip_relocation, ventura:       "864d5468d003d4097707cae69e9287fd05aedd2108c652bd7ceff92395e37a4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "825849c52109653ca8cc063c9f940d20d1c52ac631e5b6eabbf0486e3a1e5eaa"
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
