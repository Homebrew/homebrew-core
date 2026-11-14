class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.82.0.tar.gz"
  sha256 "c4ecdcbd05236bc5455c203813c73ab4598e231e6deecbd00961d3c9b04a1dc5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "54a8cbf2c4816d398e04acdc1720fb520126c794385ae0d47a65ef50b2d7f76e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d95eaaf5b23a9024a294cba46a78a5f5ab969e2ec9820c87449daac6b6da1692"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5665f9139c1a4bdfed5ef42ae7e58c5a466ac31f0a2869f6d6f1deadc5a64dbd"
    sha256 cellar: :any,                 arm64_linux:       "7f6c0a3b742cdb4f8ca25e135d54a32cd51ed162bbb2f98c81d779bc64673991"
    sha256 cellar: :any,                 x86_64_linux:      "8913e851cce42cde15b4b7c2bd8a4c11bbb0f756ac94d39ce3599e4cc7285fce"
  end

  depends_on "rust" => :build
  depends_on "git" => :test # Needs git 2.43+

  conflicts_with "wiredtiger", because: "both install `wt` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
      output = shell_output("#{bin}/wt list 2>&1")
      assert_match "Showing 1 worktree", output
    end
  end
end
