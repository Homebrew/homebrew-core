class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://github.com/alexpasmantier/television/archive/refs/tags/0.15.2.tar.gz"
  sha256 "36c97916d7062025697e6268992985e0e7c7f0b458230faaca3735d09c911cca"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50d6e2fd56e6aa3aa8cc76e1b0a672a74e48bbd25edc1058abe1e9b5f8b38b69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b16fe97684e506aae10de528ef29b0ca309ee15ab5b3d646a2e648cb1075bd57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b86e0223fc5495ebd3a14a833d5b0b733a118fdb09cec4d2f1823798fa56c99"
    sha256 cellar: :any_skip_relocation, sonoma:        "7626782ea5fab97e72d6aa456ff4407a691340914e8bb9ee9773b47bcd287016"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa092d911e6d435c8ba8ee4ff550d955b91381b227fafaf13db2953604af2baf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8742aa9ef548a20bbe788e76d2a0b54b700d1db594e135f1cec3fe92d6ec7aff"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/tv.1"

    generate_completions_from_executable(bin/"tv", "init")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tv -V")

    output = shell_output("#{bin}/tv help")
    assert_match "fuzzy finder for the terminal", output
  end
end
