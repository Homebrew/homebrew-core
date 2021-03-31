class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.0.tar.gz"
  sha256 "95c6f258fa4333b1a2a68ff619cf253018217e89e1eb9ad41c46d48398088f81"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "48e5f0f0d08778162f412655c8d342f632d6cf4e02bbec84c62d750085188f1f"
    sha256 cellar: :any_skip_relocation, big_sur:       "2dd6d04319b90b8959bb9c3a7ecaad1f6d56b7687902d037f67e0d6e2622b61f"
    sha256 cellar: :any_skip_relocation, catalina:      "094233f8bd827802a27490b00eaaf3cca46d2829c903543c715d26bdd6acd1d7"
    sha256 cellar: :any_skip_relocation, mojave:        "79da49259457386bee3fc7b1327f2570b4f8f8c85d94e612662996a0c673f141"
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
