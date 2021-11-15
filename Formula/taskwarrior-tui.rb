class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.14.14.tar.gz"
  sha256 "36fcf90e9f0ffbc3d7fedfd094de80dffe6775d77f81c9612de9bd6b70e577a6"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3797e16e8a1237bc5334fdfbd3752cb74d86f639d0b06bc176a8d7870d37a1d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48f26747628321f030f7a37ab57afeaa2929492124a72c0ab23cb3d6b1bd2140"
    sha256 cellar: :any_skip_relocation, monterey:       "e6d97884a5035889722c6b5d8358b0f04bc35ff9d35d967970729623019aff4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "973841d46d8d10e26a8df1f2d97bb86af6580be0335af05ee5f6c3f1eff3161f"
    sha256 cellar: :any_skip_relocation, catalina:       "c3c1e68396ed1439337e0aaf46b793d87f56a33e3448622494e52ad04a236bbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24b0a4651680213c5766b7708fbf99d401604d9d7fead48effa773ed9dcec698"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args

    args = %w[
      --standalone
      --to=man
    ]
    system "pandoc", *args, "docs/taskwarrior-tui.1.md", "-o", "taskwarrior-tui.1"
    man1.install "taskwarrior-tui.1"

    bash_completion.install "completions/taskwarrior-tui.bash"
    fish_completion.install "completions/taskwarrior-tui.fish"
    zsh_completion.install "completions/_taskwarrior-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "The argument '--report <STRING>' requires a value but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --report 2>&1", 2)
  end
end
