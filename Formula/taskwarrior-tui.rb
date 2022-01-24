class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.18.3.tar.gz"
  sha256 "872678b3d47901c36cf5dcaa748c5a806c0be92973191e0fac8a65af69aa743f"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1986061784b821795c2457867777c2c86760e6abf22b6b2229f69c03e7a90ee3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ae9ebacbc7fe7df18d1bb6f39fe62d70f86e068308486ba6c94f97436ae150c"
    sha256 cellar: :any_skip_relocation, monterey:       "d6302e690bba8ea680f30de4dcfd5a4147ceffbc5d235fa4349a4c0f8440c053"
    sha256 cellar: :any_skip_relocation, big_sur:        "2159c3c7ca56eb28bdab46ca8b1ff83ffd201f3aa8f6e4430bd24788e4257c3d"
    sha256 cellar: :any_skip_relocation, catalina:       "43a9ebd4afc1944f1c804f4efbc91eeb76022630d94e1357cb22cb0a0238dcec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4ea7dc080fe87de88d4abd7ea19d1b0e08f39998fb0f4d5e7e5dbf5151e861e"
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
