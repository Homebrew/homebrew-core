class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.14.9.tar.gz"
  sha256 "d185996570971697cd2b8103763135ed95768f3cbd7a133f52754bf7d2aef9d0"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc517a3f7d409f9bafa60a8ea666e7501a2f4437ef56e6e04c91e9ccd8d7b25b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41148a6716220c3644c579430fb5a99b5d7731106b577d1c2a5dbe8dab0996d7"
    sha256 cellar: :any_skip_relocation, monterey:       "82d9b87e4a62b4371b1d91ccddf083af06b7158f7be809848d24bc12635348da"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2aa0fad2d4e9d314c46dfb1ff0a9351aa2e1881a52ee0d5ac789598fb32a2d4"
    sha256 cellar: :any_skip_relocation, catalina:       "ff91ce33e23d30ddbef97913b0aca8fe2cc259653a4b62b0e23023f32188826e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "015542d953e0a5762acde3afce9e38169731898413eb4054751c0a925e5ccb41"
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
