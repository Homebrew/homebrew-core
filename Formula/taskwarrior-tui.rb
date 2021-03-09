class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.11.1.tar.gz"
  sha256 "51a50eb3799c38cd7310f63f282cb202344b6d2026ff139ec99c8f367ecc59ea"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "39568d3defbae06e56ff930f545f092b4b992d39fd2ff2c5ac57c13cb246d2dd"
    sha256 cellar: :any_skip_relocation, big_sur:       "0fb691a64a7de4a821a425a71ac3236fdb37f8c747bdfc94eba769fd0b0ee405"
    sha256 cellar: :any_skip_relocation, catalina:      "d4a9c65884a0cc1995264a736c6ae573405c3017aae18b2aa24dc4008a8a6d0c"
    sha256 cellar: :any_skip_relocation, mojave:        "4841aedd659a1451330d676b582729ee0a0c8f5d7b8e44da07203b5cf620f4d0"
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
