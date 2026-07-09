class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.66.0.tar.gz"
  sha256 "3b636549de52c8fe78fb30d59bc143fc238b78d3413575f8991d4ccbc5c1fce9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff22f880fae43bfa1bf2552a92ff66a296c43a557b204f38e402cddffea5d3ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "356123730e52d4774a8ffa96aa74ba9c1e5ac45cfd9eec55dff78f943ba27855"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "238c3aee04a91c7d415e6b31a362482f681c5e776bba0f977122501bd422b8a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d589fcb1d9663d0c31a193bff0b9dad41e0387df2174c1b5c7129a30b24299d"
    sha256 cellar: :any,                 arm64_linux:   "a6c87e4f907d24a06bb3cf3a23f0ad14728d61902a9cd286b3b745dbf6e6fc06"
    sha256 cellar: :any,                 x86_64_linux:  "9aa7fe74572a97b640b244525b650253816db9fa0ad6b7547c14edd7c9e2e52f"
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
      output = shell_output("#{bin}/wt list")
      assert_match "Showing 1 worktree", output
    end
  end
end
