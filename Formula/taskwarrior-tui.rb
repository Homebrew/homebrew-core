class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.14.7.tar.gz"
  sha256 "7ca3401e71ed5bdeb206ad95e659f1a0c91e7051770ec8f0b11c880163cabc5d"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58f06e443e3557298cc7047ef0daacf2e274f96be5f45e9bb515740c50797cac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "485f308373626f0f966e1d3f60b57a68f1a7c2a999982ee635d145c71c40d5be"
    sha256 cellar: :any_skip_relocation, monterey:       "52460d5c1635f6b48ad75edd76b3574d7621856cbd27536fa181462bb1824b5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "43a12c95af51ff57ca2e27a721c76a622cc9675ffb0f2f8bc9e7d99967fa5b17"
    sha256 cellar: :any_skip_relocation, catalina:       "57b373eb1e3df6bef9bde8068bc95ce3a063b18ec159c031ff798c36a2bc9db3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc451f17a68fac27b2f9785c29bafe1662eee39271ac27f5599775ed110f3023"
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
