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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fcd1620f04b4544f35ae45bfce273773ce4c1f794f1ce563c9b0ebdcfc0da829"
    sha256 cellar: :any_skip_relocation, big_sur:       "bb1328ddb4ba4ddacdb6612057fcfadbd2d356bba9dbac15d690c04d5dfbe9ff"
    sha256 cellar: :any_skip_relocation, catalina:      "b49a3bfc861a9b3f81ab2c5694175657f36ae9b4d4cc5e838dc4f3ce1b2dfd1e"
    sha256 cellar: :any_skip_relocation, mojave:        "f0f49cec64f7aa6f485cd15eb7f97288e874a86a3f319135a0b14ab2e4744e0e"
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
