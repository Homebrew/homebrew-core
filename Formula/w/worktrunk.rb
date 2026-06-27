class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.61.0.tar.gz"
  sha256 "ca5bcaa607953e598dbbdd8bd1542fcd2caa65c05923368dee8b585cfbab3d70"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efdd3e2e778d3cd083799f90d40ac4e4443e83390ac87b46d26566984f0b20cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24856fde57cc9e9136bcd0e107bc918e39730cb51a9c9e4d9d899009e772d81b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f80c6824e22c9e2aa8357311a60f9fb2b89ce5ed70bdaa11beef3eee4d891de4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e019ca920f38e75e7999aee73b60e04cc3fb555afb38c8d8809d5c7b8982edbd"
    sha256 cellar: :any,                 arm64_linux:   "bb83cf447dfd418b146af42cf38307267ca649406120dbd16b4c1ddfeb35a874"
    sha256 cellar: :any,                 x86_64_linux:  "8d0cf4e4277bb029bd74cd6c9f26dd813c6efe56c69019f0a3612d1e5244336f"
  end

  depends_on "rust" => :build

  conflicts_with "wiredtiger", because: "both install `wt` binaries"

  def install
    ENV["VERGEN_GIT_DESCRIBE"] = "v#{version}"

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
