class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.142.tar.gz"
  sha256 "ba1fe34e26402764eddb3742b4289a29f3b3af150f366524ebb90023976ba901"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "694e37f4b16ad19ee0225016b8626d5adce6b5398b5b890b6a4ad4673c912898"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab5792d57a9bd96bb6814ad4b136800873c39f3ccbcfc22d6fa8b1462313d02f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6affec9f2720e91afe0b1734511dc8245171d59d8988afc241b1a01a6c70e724"
    sha256 cellar: :any_skip_relocation, ventura:        "df57ebdedc09ac767dcf1294cbdc60a529b2957f7bb57b3e61a82df989c80e9e"
    sha256 cellar: :any_skip_relocation, monterey:       "9141919d5183516b0a8f1a3f02fa15956a18070a7900964a8b134a4bd4747c2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "99c22d58083b5aa62cb23d589203f06b8e938857c6069faa6dd77e0583096fe4"
    sha256 cellar: :any_skip_relocation, catalina:       "67620ea428919f66c1ae326a97e38932d5448b99030f6f54358f2d45070ebdf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c67bce22966084ec50d2d9f6081d40a9baea4b63f743637efb582b4ffc0b79a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args
    bin.install "target/release/ruff" => "ruff"
    generate_completions_from_executable(bin/"ruff", ".", shell_parameter_format: "--generate-shell-completion=")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS
    expected = <<~EOS
      test.py:1:1: F401 `os` imported but unused
    EOS
    assert_equal expected, shell_output("#{bin}/ruff --exit-zero --quiet #{testpath}/test.py")
  end
end
