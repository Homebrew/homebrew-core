class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.170.tar.gz"
  sha256 "9fa7ba8cc218cc16b3a70241e28a6380f683e8d8663e809d495c30f9674980d1"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21453c4b94321c402374c451b99ba5c565adb545b68b2a9870e3c94d0bca689e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e12af1276ad9138118631a61299a31ee072a2aaa31d59cca00dc60f810a7e6a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a319dfe6348dc5e481c8b29f9f6136cf97b85f021ed15216933d0bca358ac734"
    sha256 cellar: :any_skip_relocation, ventura:        "a767e30f8df797531d25282b8ba9732902a63132557552843dd2d1c0fa4ae953"
    sha256 cellar: :any_skip_relocation, monterey:       "991eb1c81dc808805ab56d4aaf4296dcca42ebc383f82e27a1f212b79bd49dbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f8a6b7cd687122ce4faf6255a37ae15d71c5c370f82335b98014e8943091ba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "612e9ff0782039774140b64c556b22224d6c4efefcc22d4ac0263dd834bce910"
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

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end
