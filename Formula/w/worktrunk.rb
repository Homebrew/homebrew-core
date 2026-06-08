class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.56.0.tar.gz"
  sha256 "e3ab1bf859a399f091b6e2110163f452ad0212a35c8f4c11b99578cebec46938"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4da0362e6707021cb1d67065f3606e502a97f3fa4abf480af17e97e112b870ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "693fc7c26327e4125e37cc1e977a2e5c94e26f62edf31d321d8049445b2d9530"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da7c78bd39a26bd8d64654ae15bb8e813911099eaae684c17818b1896d038705"
    sha256 cellar: :any_skip_relocation, sonoma:        "a34513ea7a582cea57f01d336ea6a60fc2612d837083acb6a922d38422be4bf6"
    sha256 cellar: :any,                 arm64_linux:   "776aca9766113c5359e7c06400967a862e6b2df64561dc6198076f85493de7bd"
    sha256 cellar: :any,                 x86_64_linux:  "49450eec2ba90fd295daf032d325ea43b21eebbfeb84508be06c59e1b5f69a2a"
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
