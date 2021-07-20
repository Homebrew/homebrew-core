class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.27.tar.gz"
  sha256 "f23532d099311281b684ace68511c20e8c50718d806924fa42d20d24a8c64579"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bf492c3f2de7d4571fa6ecf9949c05d413aa1b87a0e5c0da450997f74e7d8c0b"
    sha256 cellar: :any_skip_relocation, big_sur:       "134101fdb0d453579325543fe6221085a44f66a2f6c80b4cd7d0c6298abe900b"
    sha256 cellar: :any_skip_relocation, catalina:      "ce2ccdb349dead18afc57d77cedd9f597a7a7054aec68aff55a6aeae2b6ff0cf"
    sha256 cellar: :any_skip_relocation, mojave:        "7ff196057db9be1cfb01cd56dc7585dcfabad46da0d0dc3656f8db91a448fa14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18783462711b408c0c4b51616ea527cba40be26715275e89a37f9924812247d4"
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
