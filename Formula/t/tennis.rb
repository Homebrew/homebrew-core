class Tennis < Formula
  desc "Print stylish CSV tables in your terminal"
  homepage "https://github.com/gurgeous/tennis"
  url "https://github.com/gurgeous/tennis/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "a6922f9da25da5b5a3e8c8114388acb0388b67338a90368964c57f31e1cc344c"
  license "MIT"
  head "https://github.com/gurgeous/tennis.git", branch: "main"

  bottle do
    manifest_sha256 "0a48e186c8e604c0ac844a54249f81eb2e50ffdcd2c1fb39549591805bd15095"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aa43e26f3201d55e03c4b191521462390782375b47a73eb9b1d2f28c9fadd94b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0375d8da3628ecb023bfe38da8b8a322698157fb78992ecb0f8d812e6ee60828"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5ce67b66a1fb8286ea93f4fb88a1f3d150a8c515457b30ee3a6d63e0023cb09a"
    sha256 cellar: :any,                 arm64_linux:       "14b5b1d9c4b000d96a5f431aa59cce6fab2e6e6f6957c50ca5524724a10a8729"
    sha256 cellar: :any,                 x86_64_linux:      "b710858bacd74153fcdaa74cc44b36ec05ea9dae912d91b03055f3f8f41dba2b"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "extra/tennis.bash" => "tennis"
    zsh_completion.install "extra/_tennis"
    man1.install "extra/tennis.1"
  end

  test do
    (testpath/"scores.csv").write <<~CSV
      name;score
      Alice;42
      Bob;7
    CSV

    output = shell_output("#{bin}/tennis --color off --delimiter ';' --title Scores #{testpath}/scores.csv")
    assert_match "Scores", output
    assert_match "Alice", output
    assert_match "42", output
  end
end
