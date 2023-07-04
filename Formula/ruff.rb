class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.276.tar.gz"
  sha256 "91d63be7aa811490819988b425d1715e9e3e28066b45b446aa2a133928d5ea35"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a566b8ad868389eafe05359484bee02b2a0cecee1437847264d53838b01f1970"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c24f2986ce75632f757d037670d5c9200b2470af707d875c93f2509abea49df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a03e50030cccbf8ef951c32508b21391b586b8d7bd7565002deb372b74b079cb"
    sha256 cellar: :any_skip_relocation, ventura:        "85ccd3e3269a841ef131fa61c2414aea40e1c3985c4f89eab7469eaca7ae15ca"
    sha256 cellar: :any_skip_relocation, monterey:       "b824b049644b11ea8192208b13593bfab812799f6985c198f13355ea7e1c6370"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7f66c973e892292c2cad50213bb2cf8fdb88d2a3c38ac6514094aabc19e8579"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e49339690db1cdd15cc8d023ce9fb2c98b5da63ff484606548df7af79d73ece8"
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
