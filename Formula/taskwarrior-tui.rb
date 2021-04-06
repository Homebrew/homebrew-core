class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.8.tar.gz"
  sha256 "1b9d9887df4c8129dabf7336fe7d11030f859a2b9dbbd8a5d82ecc4a898235c5"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "474030f582a0bea589fb71395c9c95542b21bd4ace5863f613d16250d3e8ea41"
    sha256 cellar: :any_skip_relocation, big_sur:       "b87fb1558bbe7515ab0fb0d5bc49642fb622cd0022cba2c475010ab05612a836"
    sha256 cellar: :any_skip_relocation, catalina:      "86242d7d4ee2c4cb78852edc68a2e9c96d87fa46978102efe7cd0889cf8e0677"
    sha256 cellar: :any_skip_relocation, mojave:        "daccdedbf86a29dde353bb1a9397451ba8bc00c39a721dd28b26d6ab3b77a3be"
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
