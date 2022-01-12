class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.18.2.tar.gz"
  sha256 "c3827d3ba960c1aa6e7603ce915d222fa73a7f74cf600fe56ba8825411c9a0ca"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d8a4eaf6f1c57d14062ec60f39be94bee752de15401fb9df44c88528a6f980a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da4580d0fa314f90527e011928b839e6030c2f236df5ab630795e29c6e011a03"
    sha256 cellar: :any_skip_relocation, monterey:       "952a3e560f4dcdee3ae4ecee27f7df17c59389f96636aded3799968e0a559f8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd3870eff954cae5dd04e49714a0778daecddb239de98e0ec111b6ea25143bb3"
    sha256 cellar: :any_skip_relocation, catalina:       "6a74c7f583aefca9579dfe74804edc5500eddcd2c4b37c4bbee0a072d23cc44c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "262c02725caadf75c617ea0f59d399e4eb17154a53d90d8ebf87c75cc132c6fb"
  end

  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/taskwarrior-tui.1"
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
