class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.265.tar.gz"
  sha256 "bec366a844dc007904c05f96fe0f3d5ee6e2388fd73ee1bcf0bcc192e7be82c2"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08a579ea0e60f6328667b4dd85b0d76c95fa6b854750395d8f17e35443ae9e43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd096e962d235bee9d75b1e7dee42d4f086fc6f2d4b56684eaf7e40e2d031f4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0af6611c28bd1398e059213742ba396a979242a7db27526a3ee308ac6c6f6cb"
    sha256 cellar: :any_skip_relocation, ventura:        "649175ab4eb09aa926248e80ace93d2699c2a7c537410a75f87d855995716fc0"
    sha256 cellar: :any_skip_relocation, monterey:       "3e73d5e9da783fbec4d766a1f6d6283e186da57878d04b95d416b89092124fb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d26d6c55e76935876deeb884c8ded481d7ab585f78140a7db4679dd4f36bf542"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19cccc6bf0e1fe5581321a5f598fe5c4f1fc8e22ca99a7e6178ff1fdeec9bb91"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/ruff_cli")
    generate_completions_from_executable(bin/"ruff", "generate-shell-completion")
  end

  test do
    (testpath/"test.py").write <<~EOS
      import os
    EOS

    assert_match "`os` imported but unused", shell_output("#{bin}/ruff --quiet #{testpath}/test.py", 1)
  end
end
