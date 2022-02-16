class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.19.4.tar.gz"
  sha256 "4c482a997da9503f77e597bf652d5b9fa49d98f76ead524af8379b93e8d1b0e6"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a27b651f63dcb277b7ffa6688c30730ab3e702885b0e97b18f3b727efa7bb2d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84ec0bd1bdc2ace9bfcd54c3111c75df8fec6fe805213bbaaecd12657bf7064a"
    sha256 cellar: :any_skip_relocation, monterey:       "5ad797468d8f60499a112af0aa7160bea02af8cb6e3ce745aeb110a2799ef46b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5daea76113599cad9dc8d83674d0d4ed856796597bfb67bc39c3e59c088df844"
    sha256 cellar: :any_skip_relocation, catalina:       "a25cceaf454d7fb354770463db390c27f452840043be6c891dfc45c15ca190d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2aef8d6422e09805f1605a113f084481cc80dc584f33f655b6d0d9bd355cace"
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
