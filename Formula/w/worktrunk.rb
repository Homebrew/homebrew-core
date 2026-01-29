class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.20.3.tar.gz"
  sha256 "9c93ed221f4f6d34d439f644d4924a556f9a3b7158462614fe8bfe5e1bebb6fc"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "884254afb34e4e001cf3a123c169bd8b12100c176512f77a54a632725bef700c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1faa8757cec0d4be0f863a29d9f93e959eb3e06842ca2cb5a815f347967bbdee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "971ea0b476b9580d8b6acedaef56bc17f586df61c7fc39bd1f7ed649afc9ba43"
    sha256 cellar: :any_skip_relocation, sonoma:        "2900621d69df0017fbeeadb51d4953a76b0213183aad79378dd9763de52f7421"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ae48e18b78f78d5309fb7bfb9860ed70e265251e67f147d99f050a5e708cacb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "494255954adaaa970ad37a2ae8415dc08ea09580576b67aeeb712d8fc4fd3fd5"
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
