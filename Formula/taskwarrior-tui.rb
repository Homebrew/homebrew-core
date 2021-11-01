class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.14.6.tar.gz"
  sha256 "3e36a23c67c1163a611f6841498459911307a63987aab4af03b16ed5b33d28f6"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b25ff96e4ce58e72ff1f00bf55b7b588039bc43fcab9642967763d11637f6b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5600cf3a6b49499460279c4788c90e8ac3919958f8609553401a2cd8ce2a246"
    sha256 cellar: :any_skip_relocation, monterey:       "fd36d749f258f577f67949494a23d7a9f5b8dad9c29a2f2e8cafd594e80ff253"
    sha256 cellar: :any_skip_relocation, big_sur:        "c171629544e12f8ece2f02512767931f9218a454a0ddd95c1ff3ecd62d848cf8"
    sha256 cellar: :any_skip_relocation, catalina:       "025d330b695035f7659d4c31e07644940a3e5c16f2bcbddfe48261fc6bc7fdb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20119e42901f1af6dc8f594ecd8d92ebce3b9fc6e0e2c9a8afa26fce0aed1f48"
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
