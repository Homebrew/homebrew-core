class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.20.3.tar.gz"
  sha256 "9c93ed221f4f6d34d439f644d4924a556f9a3b7158462614fe8bfe5e1bebb6fc"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64b3f276155f7495585bd9b43aeb06ebd67552e8f5270235b257a71ef11cffd2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09468983d319f23040c75b142e9846e0e86b5e46e3bbb57c99f4688f66860ed8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f57da9bcbc23609d3c981878aee3806bc637c4c9dcc5f6fac89d1f30ccd3d2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ebf48ef1139f22630832a0117c85193e8b78ef039f2e64a0ae5b23cab7ca2e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93cf70f2bd9ada5a2290bc74ea4be928604d037ce31c429e8b3f7692c0ed4884"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d905ec14d5c082a2d9bac2be7edd938b62a8c72d3a05f229ff91dbab90b995ed"
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
