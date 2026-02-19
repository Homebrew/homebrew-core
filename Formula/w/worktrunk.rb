class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "294baa3aad769ba761b559afbe8ea6c07e38ee09e672bff83e20457146246f98"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e38e1dae119f724fd69d30e6b7e877ae1850c2766ae74502c4c788ff541f77c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83066c58153cdfc92158fb0329c813041a1d0f1053aa8f1fa2e9f0a398459965"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6eeff40b8b549a848cb487e664eb1f49163b615cc0dd2a5159275620068aba0"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdd238024df9a556c655059b777b7eeafc475c503a118463f4ec8fb62545d76c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef1ef9d8bbccc0db5629df1e3d5b935c855bb7e1ca24ba69eb3cba671915a344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a297827c322d998fff309733b0e32c0ad54daf7af39bcb70ac08805edac7c09"
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
