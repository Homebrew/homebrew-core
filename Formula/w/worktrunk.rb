class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "a37dea80a8e8799938d85dface54265b34332969423fc39844f8ef0d241e17c0"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acb2d0b4da2ab0c68dfb193e9c3df4a64a9099d30b530d678019b8574a942ba5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7d7a07c0518c270f08c4083e232636ae0efd3233ed6c57a20f6a9a496cde1d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3db0a5ffc9fafb1b0d9c600e72bea40b876e9d2e2184a9d2fd6b3e0f0cd5eff"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0a72e9662071a572a4ee0aab6127ff232e09a1b6933ba59b9dfca54b803de73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8dd92d36ca8e72d05678a35f4f6f0be14925d617e1cea12ffba7324159a6f78a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0a622119ffc9c3b021cfbcc05218cf94d071005cc9815f8e57cb00afe55ff0e"
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
