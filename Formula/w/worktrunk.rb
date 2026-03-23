class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "f3a9020a00c390df0826d8dda57d1f8f509b215c75a3701b7eb8632161c0355d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e371b5807783e67b8e137b3a3ea341bef194d7b33f6a0b4578bf0f37f4735e82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb5c316d519216e99455accea6ab24265d8732aebbf7382b54be9a217fe91168"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "769c9c3d45abb1bb9717c7fbacc8138b9d915b4c42066054b20fb0783a596b2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c8ed7222123c7e935c5a5fc662bbfb6c041c1edbf8f4f134695305817ef72f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9ae237690e9b5a1064ad7462c1eccff5397f0aefa1253064885f97f1da4c924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c83879f37b7ea51e3ebd2a9bbc76473a60609722c73c68055cf61ff54f93a12c"
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
