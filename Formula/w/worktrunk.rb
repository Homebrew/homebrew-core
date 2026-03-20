class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "b87915586a8ea120afd4b620c24b2c14fe47fe0a92613f7dec7fbad611db1b41"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67e00ad114e9a62aefadf20b1bd2af8c0d902b8256995e286f23eba2b21efd6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c58b9ed35dbadadca5baf261bb4fd12073a129852cff2349506ffc2eb8d52bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c649fd8144729d3d25079df4084b8c58484ce544617b14723a7fb063fb0a0ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "5beece0827d81fe33156d13815cbcbba641adf3aa187bca1f04fe8f72b4c553a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c90e6ebdab46e35bc382008bc12e58e6aa7aa95a9c40a51015460ff42d755955"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a420d1ed35b061dac0880a5ecc5518621c5d83b884e911c63d9ddbc9f275820c"
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
