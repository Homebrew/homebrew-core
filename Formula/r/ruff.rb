class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://beta.ruff.rs/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/v0.0.287.tar.gz"
  sha256 "c08a7891939cf1f39bf851fd432a3690b08a72debc430e06f300211cdf9bfa4a"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fab7996b03ee2f99955f5f2d1a87f172413ca14814a1277cbcae35092762a0fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0f06c87b564e7f30a55dc1e0ae08901ea42f76f211d7c80921d7f35f2f3c06b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77b7b5544da1a47601f8439ebe4c2f1619de56fe55679f6280d40d6cea03ac05"
    sha256 cellar: :any_skip_relocation, ventura:        "c19b19eeeb78f0be1b79b3983bb335160bf8d0c6b25d995424d6614bfba6cff6"
    sha256 cellar: :any_skip_relocation, monterey:       "006d18a8121dd87c11d7d7d7fe61575e6b3cfe95b51abc9d79379a48fb7636fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb38d55ffc710fa57ec81bd0c692e4315507ab5c4cd2cd132855b6b62f1577c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fb19f749cb1913ac72ff72462630beeced690d07bce46d7a8bf6489872f5f2f"
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
