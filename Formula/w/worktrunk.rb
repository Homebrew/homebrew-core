class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "e9190598a75f124e0c3fcc3c999aae38195aa2763a562a739e0974ac4071350f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea365aeb3f11b399939d8d7804cc5c143c40c728ae008eaef8917214e211cb58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63161e202d2ade729f988729df170533c5d04148b95395903bbe1418dae6bb2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f8ce447235a6d519c3700136698652d4a219de5c24e20367eeb9ad0df90fdfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "17fb05f96ea744b150a1d8ac4451a8c3dd0ac7e5049bd3aae4cc360156f0ba3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f093652d47a4d78ee2dbce99a834ed631365df6732a8c43feb1cd10884ac035d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d10dfe2c408aca05396f7b167d03d28f539919b7f9da30b6bda726ccbae7b691"
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
