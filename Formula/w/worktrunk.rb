class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "69616860f71cfaaa2515cea8c7a8e10c3a9f68d354e7835bd140f0003b8e502e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76c8e0aae53db183a1e3457faa53270add304f5c48396f38c3cf374366f918eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c86201a62d3c5e7f3a298442a1dc5b4374a7f59f94634cd6602cb5f44124444"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01c4f8929e109c641e6b1889b8a6454df18ae494e8e15a140bbcae1677a45f61"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7bb6f447648fe4c8d040488cb7cec05b27ee9350d6d768956aa076ea75b561b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "437bae7cc523c4df2334553432f6ce74367089aa5778dc20956b03550675d6a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78dcf9bda3de3434d2ff1b42a256992b4769dbb506e07a975115c8287aa41b30"
  end

  depends_on "rust" => :build

  conflicts_with "wiredtiger", because: "both install `wt` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"wt", "config", "shell", "completions")
  end

  test do
    system "git", "init", "test-repo"

    cd "test-repo" do
      system "git", "config", "user.email", "test@example.com"
      system "git", "config", "user.name", "Test User"
      system "git", "commit", "--allow-empty", "-m", "Initial commit"

      # Test that wt can list worktrees (output includes worktree count)
      output = shell_output("#{bin}/wt list")
      assert_match "Showing 1 worktree", output
    end
  end
end
