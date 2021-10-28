class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.14.0.tar.gz"
  sha256 "2654b640fde8b50a21cca0818d916bc5490b6c95770ae1cf569ae1f49fee0903"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf6909ac6b5b03e44fd3811adef10cacc5446e114d115488da1be9157422f312"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f675973e3b9ba4ae28938ed538e0c0817dcf646ee6a2d90ae3f0f7197c17fbd"
    sha256 cellar: :any_skip_relocation, monterey:       "8c5168a3d3aad2fc1a136c4216bfc19803f1725485ce37a1fb38ac1df371f0cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "5df0b6997fa8a205e4d0e0c9f40fbfb0919e16cd9c49b5506e9884278ec6b4f7"
    sha256 cellar: :any_skip_relocation, catalina:       "07537d83dbcd704372445d4ccd110cfdd82155226118f39e8cc7d5b1117d7d18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba111ca26f701eb07ef2370ddc320fc1a568fbe763be86dc250de27ac474aca6"
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
    assert_match "The argument '--report <STRING>' requires a value but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --report 2>&1", 2)
  end
end
