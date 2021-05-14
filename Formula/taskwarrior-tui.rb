class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.23.tar.gz"
  sha256 "cb811ea85125ae9435b6b0124cd51ce556e502174f9ddddb22793ac0fc280357"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9216ea12deea17e22a8ea4ab3d647f79ccd82ed04dc7568fc96cb2b6b6c24c71"
    sha256 cellar: :any_skip_relocation, big_sur:       "8571a4150cd6e2035914d0b5fdf2fe5b89c45e586a9697d401122c0917014593"
    sha256 cellar: :any_skip_relocation, catalina:      "d5733ee0e17f29447a988a5dc399a7024e191d3aad729fc343b47cef84c4ee6d"
    sha256 cellar: :any_skip_relocation, mojave:        "a59fcf43955725400e66c81973da9e34352f3b4c2f12285d477dc49ae80b529d"
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
