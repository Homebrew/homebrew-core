class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.34.1.tar.gz"
  sha256 "1f173b8ab34c08d7fa1b1c5cfdad3dc68c6325464e8e6734066b47f490d5a0fe"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42851595e1a8ba2ae4e9149d0b2850c83786466798bb6f41eb67cb02c9adbd5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b473a76f9230d93d36a3d600b68f5960b53d48cf9ad97352e466eb86447ad1ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ef45f47e69aac1446f4bd2d55f9af9177e043a591af22a68c3031988f116dbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc2f861c765443add8f7f5953c6a865026c35a282fe384dada241dbb2b1e6b56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb4964ffefae7fcbd4281b4c975fb0f450332b7c7bc9a4fc9ffdddf162308ba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0dbbbf51d0b31cd35bbf35086ede169e1fc2b35392b02e58d9dbd7ec45b8e420"
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
