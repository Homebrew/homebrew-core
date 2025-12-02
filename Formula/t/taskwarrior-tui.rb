class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://kdheepak.com/taskwarrior-tui/"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/refs/tags/v0.26.4.tar.gz"
  sha256 "064ab8a4a7f057ed00a6cf061bf124607d5b4812fce145fd60efa7315c765625"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8656e616b9620edb3913d44f735f64c9dd0dd11a4081a2626fe63b870718529"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4783503eeb0862c5afd092060312490f63f1df82a0d5150d7f8763deee220a1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59163fdd5bfadd3f071a0dfe9323d4f53302edde36018a142aaf96dc369ce3a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ac3c7628ba3bc1595f3b4de4354b7a48df50fff065aef9162cc1f02f50eeb65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "831ba8c0d9f38f98ee43ba9b453646505019790c162dd7639aab5a71ff18416f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf53d6f867842191056512d1900734fd848cafc662f6d866c9ae55ee5b77c6d1"
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
