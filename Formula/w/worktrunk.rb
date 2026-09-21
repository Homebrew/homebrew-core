class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.79.0.tar.gz"
  sha256 "598ac74bd4af6640971720ea38a04537f0bc30e4cfd35cf5848e7604d9696558"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c1b15465f6368610dd0d916ef5c5db5790352e47f2620f4634b4c21d61e7fa00"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3292444f76010e2d62655225fef99c0e0fe33c08a411a0fdad0b42ee5a495c66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4b27b60ab099992f256745050e3f45c70d9e20b66ad3cf1560d36f02d45982f8"
    sha256 cellar: :any,                 arm64_linux:       "e26b93b1f92b7e7bd708a21cca224946825330b3e964b19c16eccb1a4554af9f"
    sha256 cellar: :any,                 x86_64_linux:      "5c2d6041ae72c29dfbb5077318974a24e5264c65963c6c37eccb411f4c338093"
  end

  depends_on "rust" => :build
  depends_on "git" => :test # Needs git 2.43+

  conflicts_with "wiredtiger", because: "both install `wt` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
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
