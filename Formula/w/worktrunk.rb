class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "8abf8e85658d95d76a847363be9d135f00a7d2f0f289183cd26df32ad6c80d0b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47a4088b350b8cfe406c08934fc77cd505a68ee7ad1fa07a6b91e5af6c8ed9ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d752d99466ac6b330992b1f2c7da3d635b41e917e7fdb90f16fc63676ede1c20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b5e22fe58067566a4f333e6b8526f3d7d13401ad7e2aeb36dac0a51e47ca8ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "a26b5119b5f66200fdc1edfb22ce6c0a58fbc0d27a153ebaba34239c5063a615"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b98d1fba002bca8d23e769ac5a31f3f349a4a55cd94f65a5d8b7b87d232f305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d1d590c812fb648172b0447a3b7bea5ce65a431114a8d8c07d2bd11cf7b5de1"
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
