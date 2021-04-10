class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.12.tar.gz"
  sha256 "157962def97cb91fcae07ec23f318221f869f96a124a46a3bda897582e4da9b1"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6fe5613a7b890f6fd908b9143a1d63080da7541d20a3008a131b51adbb9cc67b"
    sha256 cellar: :any_skip_relocation, big_sur:       "d05c70cb681da20f1b2d4a1a32cd1e99795db66fda288acd179ddd6c0f1b28a1"
    sha256 cellar: :any_skip_relocation, catalina:      "d950c30646c7326422c794b0d44134fb8088b6ba9540a0f49de3c607086d3584"
    sha256 cellar: :any_skip_relocation, mojave:        "2bb531461a6782700919364a3d3fdae94034745b6df5cd5e53ca440db1dc00fa"
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
