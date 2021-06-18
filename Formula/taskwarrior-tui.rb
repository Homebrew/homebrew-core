class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.24.tar.gz"
  sha256 "2515daf92c28d8ccd86593049cba7bf59977f5df1daf814208d50aae7732be84"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e33ddbdb7101ec7aac6e98e45de434056462a338ecf6c065468cfba6670a88fd"
    sha256 cellar: :any_skip_relocation, big_sur:       "6fbf1f225a09ba9d503a02812d75b903cb2653f2485770605e66e08624fda2d6"
    sha256 cellar: :any_skip_relocation, catalina:      "1d5a0b9ad5706b01bac2346379f08d69615d756551f5e878b7ab26057aa3a20a"
    sha256 cellar: :any_skip_relocation, mojave:        "437e9b59019bbd750276bc0913db8351e56c66d8d0d8f0e2664d3a5fc7b74d24"
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
