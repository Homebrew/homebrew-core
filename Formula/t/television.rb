class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://alexpasmantier.github.io/television/"
  url "https://github.com/alexpasmantier/television/archive/refs/tags/0.15.9.tar.gz"
  sha256 "5f46cbe7b14e1d6e3958f436b1d6ed8af86e9914d7d2aee5a9379e8e1772072d"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "846928fc409711e871efb4e1fc1806a58983a9e229d55dd1a2af7b1ea3226035"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "477fd29521ab2ee4db2074ca9a64be5383c964130ae25a3cabc0b283735131d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "767df4edb496c67c1235bbc04bb3ccca6415947db3614dc4798103913da95a5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "eae2098d2767f3e4a84fbb597e0b58c0b3ad1f5434a24a8b8a6bfc7e2188ff45"
    sha256 cellar: :any,                 arm64_linux:   "af35feed5bcd6089735541def201f47ebe2dc06e83e0777dd4528604f5f07769"
    sha256 cellar: :any,                 x86_64_linux:  "f4d7bf69ef545b58d58363c109d89de81d6a23faec26169d9365688768a94561"
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
