class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "11d494f5e42e8ba194dc3a58b11bece84b3aedb8c3c37a059217bfe7731bb4b9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1632e095b7e91aa72f4637b76c21bb8f1405cef01f7d59d9fb9e74f6d86a0a9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b192f8f52a81dfdaa08ab7dcf41bc3263e5dc995f4271a7208bc01275c882243"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b45db13ea460794156c5adfbca9cac670717d020b3a6fb0e9528be5a3263598"
    sha256 cellar: :any_skip_relocation, sonoma:        "42d8867963dbf6320da7dcef38981e7e3a67373f11e1c00be0c2806954a86270"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15d977f1340584ea748975d0e89fe26a4926f8a7ede71990a1927349c064763a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27bccf3114429abeec889216c0a78f62448cc0c95ee4964ecd56800e3c54884a"
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
