class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "f31d179ddc11297f33a509069f72efdc542350274d490c2be063287ef0290579"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "95c56e4d22be73c19d9d8213fea0bb54f73d6363895f426d4884685a9e2b1a45"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4842aab4efeb1b5912079e69f5d7df1a077719d57683e464c7bafbf8ccadb144"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a52c936080059c9e610cf8a9bb4e438c951360d16dba458bd3dedb06ff84044"
    sha256 cellar: :any_skip_relocation, sonoma:         "499df39c63ff85b1fbdb0f4fa99d73a4ec495cbbaa08e754f4d6a517497f73b6"
    sha256 cellar: :any_skip_relocation, ventura:        "5dabb95322053e99828b89c561e35de22d924b408bc83faa27ac31187cc345b9"
    sha256 cellar: :any_skip_relocation, monterey:       "c371cd5a38cfb42bcccc1bbd3a7f62fabd00fb903ba1d7b49bd7bba2d5cf8eb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80eac18dcfa18dcd9a25050424b6f64d8ad6f724ccd956d908c610dbd0622311"
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
