class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.14.8.tar.gz"
  sha256 "b04634eb37509443415bb44226dfee46d29c159d5ab99697b3c71e1d2cc72008"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e8b23ce4138382f8a838cc711ccd7e20aad68f94aa5c6cd145ea797b6489d63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "066891352328c15d63822c8b7d30b95c1becf48388343b085c183ec6a167ba92"
    sha256 cellar: :any_skip_relocation, monterey:       "4b4cedbb0db849411605317cda23145aa83c439efc94b7f3035ce2e796eea572"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6ed2a5a2c9239ab227f1df82d07237c60580cbcd145062fd04400f81a66d19e"
    sha256 cellar: :any_skip_relocation, catalina:       "ea2ce91dbfb3c66c833b82cf56587ee1e4a08d76b0433a0e0fd580f5fdd0a85c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "722f355bfb1741f0c2fd95e0b23220bd32c5ee5833e8604f5b927ba8721d8733"
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
