class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.2.tar.gz"
  sha256 "53203b89206b5477a389e0b7627e890654802c8f091238ea5cf72e47375e6878"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9b074eae1a56b7ba8b39759f5bb70da9da5e1acb605f2274a0e7d9e3aaeebfc7"
    sha256 cellar: :any_skip_relocation, big_sur:       "92d9f0c9262db5b75ed7387c9a1064b9c78c99eb7f0bdac2ab12d825f6a299da"
    sha256 cellar: :any_skip_relocation, catalina:      "008c1c43f5c90b4b8ceba6bcd7d970916a652178af1182064203516bfda81f80"
    sha256 cellar: :any_skip_relocation, mojave:        "1d47c9ac461f15746296fd1528a397129cae250a172d4257e37bb2a3aba2a16f"
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
