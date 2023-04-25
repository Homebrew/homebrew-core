class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.262.tar.gz"
  sha256 "d8e68e2499199ee7735a597b4b9e7ad660131023908b0f4e56fe664d89087bc0"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bae8b51b58f008235c7071ad69f5a3eea7e7d00b8e6938065ee09b961300456b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f1225eb3bf590d3f11e49238e32ae010e92f5b337a89a8e6330aff21364d218"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9117c75a14e732e580fe1a0f78fd059c62032d1a60699648e2aa985d93370ac"
    sha256 cellar: :any_skip_relocation, ventura:        "bd88a5985c5f44dd36bd0102b4db87ab1f4e22d826add8fa1cef8d83976708e3"
    sha256 cellar: :any_skip_relocation, monterey:       "5309e4ef011251220d12f087765ebad3a9b707e7700c27cbc688805c757efda6"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe8ef0a36eb3a80c8086e865014235fedd3746a71fda6561b66a403509de823b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3f728f7558e0672154b9d21146780f95a8d900737d6dc056177dcdc4e3751ea"
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
