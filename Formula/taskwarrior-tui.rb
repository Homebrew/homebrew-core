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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "04687892b0080687e67fb71adaa547ad2e8f97707431d95099ee49b5edd38835"
    sha256 cellar: :any_skip_relocation, big_sur:       "614743b445518a0689be4aa55fa32348ab11171faceca34df1bbd25c72e779f5"
    sha256 cellar: :any_skip_relocation, catalina:      "880ceb0ade1d6ae560a509cf93ba2afd29f378616a39026eab6b7365887bb8c4"
    sha256 cellar: :any_skip_relocation, mojave:        "4c70cd5924917bb36f0c6079b922315c1097934e7ddee11764bf94b31fd7cc49"
  end

  depends_on "pandoc" => :build unless Hardware::CPU.arm?
  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
    unless Hardware::CPU.arm?
      args = %w[
        --standalone
        --to=man
      ]
      system "pandoc", *args, "docs/taskwarrior-tui.1.md", "-o", "taskwarrior-tui.1"
      man1.install "taskwarrior-tui.1"
    end
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
