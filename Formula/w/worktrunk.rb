class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.35.3.tar.gz"
  sha256 "8fa9a2401abba1aa6099e2a2caf68b1ac363fa60ce5829f7b6afce0c36b489c2"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b8b8b39fe3be9783e2489eda112fc9b13863cc386918a3a5483ac231f603b7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b01104792a9549c9c48bbd1f57e40965cb498f6417e0ef5c1551145293906da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04869c358b4aab89c10d88d247bdfd1e776dfc554a179567d3dba0ab9b6045ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "80b3b607538b06fe59a4d5e565011cc6fb15b4bd0471a9013f97485f55536db9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d365b5405070593857132c3cead4bf3acdb7386caa9fa61a76082fd9ab8c078c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8385210ac053884850aadfc26def1c214595423264c21e90ba88f25e90f4b40"
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
