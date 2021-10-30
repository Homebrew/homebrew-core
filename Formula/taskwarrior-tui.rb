class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.14.4.tar.gz"
  sha256 "7e8c561b6d45c7b11545fbdb47bdc2c048cfda088e9de77a37191839acdd6d83"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63216ec68ccfa837d0e313b41e20fd4c726a0932f47b269f773a6c4dc7b91f22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68cf4060c938925e57f2be3cf24bdd8f621a0b190bd7034dd246a3337c4c9cc5"
    sha256 cellar: :any_skip_relocation, monterey:       "f9370b15f58109a4b4c9cc88782e5b8033601f47cd13e13385be2c913392a167"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4e43dd3a25a08550bc41e27985283183bf9697b7466be5bff318dab1146aba7"
    sha256 cellar: :any_skip_relocation, catalina:       "8db008598992ae47aae30e72b595ba4cd115abf24d7cd9a2198b43990739dc8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f04355d9028b1dd5f3ccb3ccf2cb2ea425aeae43bf3027a9be9cf674bd3eee10"
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
