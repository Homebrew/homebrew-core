class Ruff < Formula
  desc "Extremely fast Python linter, written in Rust"
  homepage "https://docs.astral.sh/ruff/"
  url "https://github.com/astral-sh/ruff/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "36d900e3514739a9149363a087512222895f15244bd6612e299259be8ac8c1df"
  license "MIT"
  head "https://github.com/astral-sh/ruff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "01f43231a1730526653cd72657a07645c04190a40fff78c9dc8c2b355edcfd55"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d453b18e828b8fa426d9a24cefe6a1f05c5ea46d3e837fabd6fe02a40d3a654"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d75bb953b47c9e0d57ef3cef9a6beeb830a7a5f0f047e0b955ee6e8c4abf4c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe417bafa882fbc0a2d88e2601c29655dd4b722800d115756c69baf9a197b069"
    sha256 cellar: :any_skip_relocation, ventura:        "f4b3c47eef5d31abf34229eb433f504a66f9f93c6d13abe4656f16091bcbcbd5"
    sha256 cellar: :any_skip_relocation, monterey:       "e92e557e1fa16ae905ebf7f0cb11e8507468b94377dbc2f2485d8d3520a9094f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c585d4981a49a2c02343e732819894f5a451d8c0054cced2a5c80ecfa4c290c4"
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
