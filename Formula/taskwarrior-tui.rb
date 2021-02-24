class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.10.4.tar.gz"
  sha256 "5e8ec1b0db8d8dd34e436fe1d0a3889b7330603a92f83e67f2615322e39dda9b"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "89783ba393c9be8f855babc6d5f363805215674e115b9d2a2cc216b6ca07518a"
    sha256 cellar: :any_skip_relocation, big_sur:       "790a56edcfc50cd8a7c0135d1ff2da26a40df255d3ee7070b3abc7a84b098227"
    sha256 cellar: :any_skip_relocation, catalina:      "1d65a7572873cf41ab05bd8307604cca572d30b8a065b30340c350d3313ac1d0"
    sha256 cellar: :any_skip_relocation, mojave:        "a6d58f5fa6ccb917a4d8df68cc279b5d7ed83584b3265615de2ceea04f95904f"
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
