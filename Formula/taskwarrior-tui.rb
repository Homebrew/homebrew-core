class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.33.tar.gz"
  sha256 "7a3e3808455db7d9d70fc3eb54dfd938f90ce481b2b56045014a8ebe20453083"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6e61ff2d9559b8a74ebb76b1ac59cea33622273f6a265591af13d1663433970b"
    sha256 cellar: :any_skip_relocation, big_sur:       "bd144eea80f4b5167e95b75381c1d22da53aec2937507bf42159b667857132cd"
    sha256 cellar: :any_skip_relocation, catalina:      "45baf93811aa963bd0dd63cffd1ba61ba464b6f2815a86c705279ccb42610a34"
    sha256 cellar: :any_skip_relocation, mojave:        "e28680a1bfcbba6782e3d379d9d6845dfe9069f5a26745eda1e192814acfb04a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62addd72867e56a7ce9c1862e4786c0f5e0d370a468d2e32a003bfafbbf04a7d"
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
    assert_match "The argument '--config <FILE>' requires a value but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --config 2>&1", 2)
  end
end
