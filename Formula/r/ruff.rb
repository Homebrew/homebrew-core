class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/v0.4.9.tar.gz"
  sha256 "815c5b9b316a4d72dc526c6b4b2421df708556294af514e6fe25ff99722d36e3"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7249398e31006ec23e05d398a467118a72cac4560428e2bdbaa55e7b79573195"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0c922bfa54f6f608c3ffba074780981677cfffc10fc90cddad853af85a4dc07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbca19f0a59af3e7ea6f8b89270d33ef65a4301180407ef58f12f48393545f30"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5c3f8b774838c2935d8baab5371989502464addd073006669968ef1117fad5e"
    sha256 cellar: :any_skip_relocation, ventura:        "bfd98731b51f28b2a365db3e9305423256805b9a71d7811f49f45c02c4ed435a"
    sha256 cellar: :any_skip_relocation, monterey:       "d15db378342eedd0a757a69e17f98b193768e4929e83f9d0f25be84f4463e9c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bbaa093ebd9863e4f1d840912269415c1a0e1debb3236d326860ea8c0667465"
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
