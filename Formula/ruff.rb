class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://github.com/charliermarsh/ruff"
  url "https://github.com/charliermarsh/ruff/archive/refs/tags/v0.0.272.tar.gz"
  sha256 "368b163f12dbf587c73948ab650feb3c5229939c3154930c67a3b6a4b4eb0673"
  license "MIT"
  head "https://github.com/charliermarsh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d834945c135e099918ea8e895ec0f158e4410958dfb1da3e97580010e4739b63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1302c76444d84a4608171ced1700910e16aeefadc8aef02989a7cc1d5cac043c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6188f396a7cfb7fa125616cd6df0efe8f1ad5d05fcad0d4a5a9e555cd7380650"
    sha256 cellar: :any_skip_relocation, ventura:        "f557b8a76893b5de0b37a54939a8118d56af92e2c2e81cbcba0b1bde87776d11"
    sha256 cellar: :any_skip_relocation, monterey:       "8a397f3edb941760510b4fb2045e81edd79e2e717d7375b42938bc63b3552fd4"
    sha256 cellar: :any_skip_relocation, big_sur:        "da8b8c81d2e8e440b7bca1677d89737f378d0d0cd45aec07281e6467af8eb372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e65efe9337c737e1d1033d9ede5a7c4654ffdacbed930f8b6fd0ec5d6a8913b"
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
