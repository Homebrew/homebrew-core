class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "6b52a5683b0fede15bcfff8d345a04b66bab190f8bc8f386e6e8e9dd84295c34"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "46536b6dd1ef645963cd54cd9f2a83676ec144da9db04e0a601011be419761f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e759ca0be8e9b15dae0969e2f316a417205e58b9444548346b6cb652b6b02aa9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f93ff118147327ec58df86c83cff213aef17d8e8452175f9b2aebfc150270bf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "aeec2d32a43a734bf8d010e29df2500368a4e79936c8075488afccc2fa7d3240"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5dd11915e0622739a3f60a5f47365e3eb6115bb9a008eb01f50b6360a1ed7567"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dda8655c22729ed345399670ebc79b1f05b4cb87e1f48ded0a8112f2794e731"
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
