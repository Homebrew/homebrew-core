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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8ac0486670900423ab12446111f51d9b1d9f9b043b2f02e998365e85b1c14df7"
    sha256 cellar: :any_skip_relocation, big_sur:       "b5e045fead8e5dc18a0404ebf3fc7d142c4366d191a35098bff7e05019915def"
    sha256 cellar: :any_skip_relocation, catalina:      "440c496b35619f3023623bf80dbf306099c9482d1d3672be425f118aa325e2a8"
    sha256 cellar: :any_skip_relocation, mojave:        "538e1566b782fc568ae4745326365e70065c82f2dda1e0157e3992f36ec75bc6"
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
