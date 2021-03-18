class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.12.1.tar.gz"
  sha256 "d9046071b96cf01a5fc0c0d899d244a21fc3c5fa95deed9cd6db5dc4dcfe87cc"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d598914134637645544c31b057cfff92aa54036a300fe9b665315173e07bf687"
    sha256 cellar: :any_skip_relocation, big_sur:       "5b1b73ec1fc1bf3e2ebd2a6a5b789345f81a60e57a18605936aad3a6a461bdc6"
    sha256 cellar: :any_skip_relocation, catalina:      "c5c0b74a3903c10f5e544a46f221ee178f6bc13c9c8911552367d7caa3542276"
    sha256 cellar: :any_skip_relocation, mojave:        "30a0baec2dda9e297116b844839786b6e2b30b7c6fe7f7cba514525f9e443fd2"
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
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "The argument '--config <FILE>' requires a value but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --config 2>&1", 1)
  end
end
