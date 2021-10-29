class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.14.3.tar.gz"
  sha256 "8e9c568f45e1b836fcbb38d354c2ce595a54c5043ff3e130e01ebca9db7e0acf"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0de2d46721ea72f15302149c1b1825b13701e83283490e0cadcc2e9554117449"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "261ee2f297a434545e0c7c6acb5d0d5f7ecc8746fde0c3fa7a13832497efcc32"
    sha256 cellar: :any_skip_relocation, monterey:       "4a5f0b5c1b54b15739fbdc2c4e904e0f38ce56aec68a24feae3a5e4a9fdbe432"
    sha256 cellar: :any_skip_relocation, big_sur:        "391eb75971364f11decae54a95ab3081d38581af7f01b19aa19401abcb1b5375"
    sha256 cellar: :any_skip_relocation, catalina:       "bfb8d93a153c2350dfec908944bc69590ab186480d9f637398775e6f2191fcb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4e31d4a9e8afb257ba24ab651513d107688476cbd4362ebd65130b088f3b6bd"
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
