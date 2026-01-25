class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "1d88148d921cd441e941f6c9da7076160b44ec74ce2cec78c353a380ac4eed28"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8646fc11c04f606a3b1c4d33708aab45e86fa57e76e625a9786e0a25ceee3cb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "516ad0d13eaf4c85dd18a78be8e94c8e2ead75ebfc229d9e499dad71de666d8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cdd6187bb4e59264e366c3fcb11886088c80b6221c4df1cf9c9c7a5d07aae9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ff21fa8000a53d18cb7fffcf6c7dee156db0bee9cc9197abae2501fdb7ce074"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "358120e55ddfe8bd91c1f1736912268dbaad58b738b7199159b4089dba7f52ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21fc07957b715db8bfe89bbf228e75bdf99581aa0d337174c17b0619dc2c3cb1"
  end

  depends_on "rust" => :build

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
