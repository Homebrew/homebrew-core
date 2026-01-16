class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://kdheepak.com/taskwarrior-tui/"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/refs/tags/v0.26.5.tar.gz"
  sha256 "9eebb2f736693cbb64b3a79b88d3e5bbae8603ef9206d47e555c9a9cf9077708"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c6f8b874e37ead71dffb8014f21b1a64b7cc63bb34751e8609f29548d902e87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "969332438c3a9f41790608dff1603b50a0a90687fdb1992e45900666e1a2876e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed513520272f51eb9f69d1c1dcc09e12a4b024aa7b3dd2d317348e2f63c6f6f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a1c8b0848787f3a0d5504d6669cc96d92525068185df20c990e9f845fa2e9d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d272aad52c1837a9b4b9c337699e6de3ec9b9844f1fdc7d5c3527ebe76c658cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b20fe0076fb6c6cbd76af7d9d836a0cb2ec736a3d30d57d9790d0407fdc742a2"
  end

  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/taskwarrior-tui.1"
    bash_completion.install "completions/taskwarrior-tui.bash" => "taskwarrior-tui"
    fish_completion.install "completions/taskwarrior-tui.fish"
    zsh_completion.install "completions/_taskwarrior-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "a value is required for '--report <STRING>' but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --report 2>&1", 2)
  end
end
