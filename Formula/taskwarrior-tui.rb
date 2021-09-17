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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6e7a950635e78e171d13d92cf21a1f0e5ecf14185c3676a0767397dba45e2f15"
    sha256 cellar: :any_skip_relocation, big_sur:       "486268235ccbdf95c2171abac2ee0c4437fe667ed883ed5859134f2d48dfad44"
    sha256 cellar: :any_skip_relocation, catalina:      "cf5d7d5fd9ad57a386ec55483c3578123789933a13721556463555987be6b892"
    sha256 cellar: :any_skip_relocation, mojave:        "40a89c1d6aa52d836e0e786cd243ae5f77c1cf670524ae24365867cac0dc8543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45a04ccc290b2ed43fcd17ddc37801e4b5bd4154ec4c034236e286a5452afaa4"
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
