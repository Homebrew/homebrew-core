class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.20.1.tar.gz"
  sha256 "a308d44cec4693fa1595b48d938ae7398743b8073de0ffce4ea9214f66c4b1e1"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d98910126424e34115fb44c8a8e2cc702edcf2dafa89518470185380f5536185"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50925e1f149e1c601c4b42c8e53bedc9571f1a83826e50c8f98533067bf4c463"
    sha256 cellar: :any_skip_relocation, monterey:       "5142a7db49f66d0e1a1fed94eb3174d4c8e2c66b42a01ba626698ce35ae749e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e664b4d2ef4d2e2f61cfb82bbab17b07ec38985f9d58410d96e1e449b6c6582"
    sha256 cellar: :any_skip_relocation, catalina:       "20fe28fe0465bc6acaf8732564392a0f67b0b61d673d961c195575018d224c8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ea744681eaea278e2b49413ef92a6256e4e44ecab77fdbbb99a66951c418905"
  end

  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/taskwarrior-tui.1"
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
