class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://kdheepak.com/taskwarrior-tui/"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "e4f5d10428dc1917b6084b5b0ed502ffe691cb14908cedd04ffff3940f9ffceb"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96fa2c2c88328272ecf5576f66421c7ff5d3b0d83b134e1902dce92aa6fb4820"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74b3d43a88bfe85b4ede427d3ad6f6853ec45bace2b77f9370bbe1c29366f5a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95d5f87930adca5ebdd842a0f4e1bde95bfd8e8ac45c5dab5f6caa61161fcd34"
    sha256 cellar: :any_skip_relocation, sonoma:        "e41e2ed971eb6cbcb10d174ce289d86b22ca355da8b33596055762338073cfd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d20bb60227e589b1256b2cc2836b24dabb5b6da7338de4eca7789c4a111b69c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c13a3a3ea04834d7bb9148fea311d340cb9c55940af512cf18835647795484ef"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args

    args = %w[
      --standalone
      --from=markdown
      --to=man
    ]
    system "pandoc", *args, "packaging/man/taskwarrior-tui.1.md", "-o", "taskwarrior-tui.1"
    man1.install "taskwarrior-tui.1"

    bash_completion.install "completions/taskwarrior-tui.bash" => "taskwarrior-tui"
    fish_completion.install "completions/taskwarrior-tui.fish"
    zsh_completion.install "completions/_taskwarrior-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "a value is required for '--report <STRING>' but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --report 2>&1", 2)
  end
end
