class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.83.0.tar.gz"
  sha256 "66d22decd0484defc701c4df2ac141f8b000fb17bbc9e8b2d9f12d00f456ec20"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "5979839f96331187b91582fb5ad11a4deb248351cf11f9df25051918c1c6d7ff"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4269bbde50ce4a639675bdee2f8db5f0119960230f592e09ac71843f3fa9f747"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c0e43768672f4c74a44f39cb0b10c399aa31d866aa236a9ffd886f8cc8ceafcd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "981356b8c68eb5f1278a1a996290be05d686f8fa803382f8c64418a7c377d3b7"
    sha256 cellar: :any,                 arm64_linux:       "363e0d972858df3702fe1da342c194b59c0b3f112ca9c06634074111d1e51dd8"
    sha256 cellar: :any,                 x86_64_linux:      "88c3ccb5f25bcf650ef5ce044e6125cf3887c9fc2badb6fcc92f499fdad0e987"
  end

  depends_on "rust" => :build
  depends_on "git" => :test # Needs git 2.43+

  conflicts_with "wiredtiger", because: "both install `wt` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
