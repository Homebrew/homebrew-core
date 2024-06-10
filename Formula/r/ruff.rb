class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/v0.4.8.tar.gz"
  sha256 "983d61b9602b800e9118e9e52eeca4f8f2c3697e7d281e230619b39fa21e4c9b"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5792e4b5ef59b9fd6ff7c160dd0aab4ecbde3dc7be6fb9877416381e961f1ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df55bf968576eb9c45630a28ce637cd4827fc01f9612120a7556b3952278fed4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a15ec4efccc78c6251f274b117ff44b88103ebddf0ea1cadd4f251bfd31ff104"
    sha256 cellar: :any_skip_relocation, sonoma:         "577bc3cb42b7b10abfb04edc4a221fcea62891c38f6dd2ebbe2da54ee47dcf13"
    sha256 cellar: :any_skip_relocation, ventura:        "bdd90fa162ca091cfe85f83366695c8df20891dd470ba73ef086fb2c22e18566"
    sha256 cellar: :any_skip_relocation, monterey:       "631f033c3476321e2a133a872840dc0ad4cc67f546596d9123a17a80253fa7ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee9754ed7a428401cb5fe640f8144e41066869fb2869742eb10ea5be38c3faf3"
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

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end
