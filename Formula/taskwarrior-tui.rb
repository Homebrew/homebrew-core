class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.26.tar.gz"
  sha256 "3941ac3d250f2b0a8521e62aa61bc4f1d4b5833fb7ce6592425f1e0439c9efc9"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3c9376ee1df6f64575750aab329ca4899780f42551c36829a0f78c44d3807d90"
    sha256 cellar: :any_skip_relocation, big_sur:       "e3a80765589c1e4476d1dc0da924272288b4a82f0f6e7694cceaaf6282643caa"
    sha256 cellar: :any_skip_relocation, catalina:      "b0b71574dd4eb50def646d59f10022cfc4b87d9485e13ca7d8e5b930b68860f4"
    sha256 cellar: :any_skip_relocation, mojave:        "26ffeeb7fd03135b055daff2dbecbe3f118f15b000c0d0da6807bd9ef1692e93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f2ce2802df5bfe3cf33ef2aeb6cfaa77f54364a802dc0c8a39a4822e42b1ac7"
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
