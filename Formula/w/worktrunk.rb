class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.68.0.tar.gz"
  sha256 "1c26e36b76307b45f19baeb87e09a49cfea281b83b04339bcbdb3115848fdac7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c84db110e82a1af605c53e1c980c198a2ae134d04763165706f5b23dab8b3703"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e332981be77ef0fa02d18d0962e5e392051bfb8f4ff42be0ba91196f574e6b2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "deef8d0939e5b936761082a707e2e218a58e8d8aa49c1df10090bb48f256336f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac4ebe852a22ed7b7e3f6211615db68b0e3f9597ed93891678fae0b36459ca97"
    sha256 cellar: :any,                 arm64_linux:   "b7a738f8431e6dc1cfc78511cff9ce36cf2fa4396461c083e5a50d8d543604d8"
    sha256 cellar: :any,                 x86_64_linux:  "9e9025524a3378010e7c74ca9cde226d54cba6991360a5d7ddf419a32f99244a"
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
      output = shell_output("#{bin}/wt list 2>&1")
      assert_match "Showing 1 worktree", output
    end
  end
end
