class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.14.5.tar.gz"
  sha256 "8ca23c9b0eab8719ad68a309c1afa44a420fd50f9b28200d128223f6a1f88981"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff4db06970065146646aa894c9d2b1ab4ed6259e66226fa62c17d422bad8439a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1b0ecb47a954dfdff2fe69c285ea3c64218852dc81437dfe6b9304c902b2500"
    sha256 cellar: :any_skip_relocation, monterey:       "4b69631a0b86b3125db152463d2aade1deb4ccdb35043e176209434acb5e0865"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e61a3555cc85c5b21daf22e2b734a472e82988e74c743ea9b6fb726291d029c"
    sha256 cellar: :any_skip_relocation, catalina:       "edc138b98b90fed186803568655f1a890d4eaaafd728e36ea020f7f976f9387b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94f3f6f3aa0c95740656d486f794a44665e2160f252ed53736a2d9c0f44a8bfb"
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
