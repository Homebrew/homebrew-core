class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.16.0.tar.gz"
  sha256 "57d2b812fd48aa1353352f3fdd659cbcf223fbc00968285f8374201eedb5010c"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b340e3d553ec7ba22b284c7c4e393f4bdcc4e5752a95002a1f2a84534b4e6d75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e91690e2559221eec3e14533974bc1b487d8625cf0d397fa804bfe6017237f1"
    sha256 cellar: :any_skip_relocation, monterey:       "773d6f438d2fd5a41f77459c95a54c40be3a3368cd6ddc0ff081cd8a3ff9c134"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7585fb468ca283d96f59b7ab92bde5c7e52d3fe2b2e797ef4f918589383d3fc"
    sha256 cellar: :any_skip_relocation, catalina:       "c7e5a28add6ab142d0cfe63a3f8128bedf12e101d5a9a9754e76abe5dae9f323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c30ea37e61956885d859efa49465614e1fd0a221d0ac552c52f6c37e20fcb3b2"
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
