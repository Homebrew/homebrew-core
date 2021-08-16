class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.32.tar.gz"
  sha256 "cfae05e79a1fad594503a36de287c2756afd5ad4514ae613f7cd0e4ed656dbe8"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "11ddea87f689c9f16d84de8c1d69ad2544653603310530fa20e9260de30b6392"
    sha256 cellar: :any_skip_relocation, big_sur:       "ca1b33da5fb85b7286f2f016096793711d3a427346dfd7e3463b710cef2f9d92"
    sha256 cellar: :any_skip_relocation, catalina:      "82290585c2173ae637bee99da71301ff482341cdbc5e19fed063502742c1c784"
    sha256 cellar: :any_skip_relocation, mojave:        "cbdb40f09f1fc77fafcd2513ea2bb3a5bae37646610a2e8cab2c66e04fb37381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bd5b0cd9625732ae8125b16f40afe707cc5cc682cafb3687b5e373b8b1e45a4"
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
