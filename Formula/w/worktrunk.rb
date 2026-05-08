class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "4d98ff08288d8ed785e54dcada97cebf99696f7a150ac977351ba1fa7c653ff9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f895f338874dfc522b5f97871c408be49d06297ce40e79df3a43df576afbf1ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80436429fb1fed4d876132a3fe81bcd00b63d326237326a4359248ab55922863"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04f2b34569575600fbdf4e704893abe4451a3183f98b6cc593171c097b0b46be"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d9ff19b596c2dedd1a1dde5e865116bdd391e31b9ff7477d21d378676643061"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12af3f96a98015d0291a749454748d3575364db246818057e048131c38919966"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fe2b8e25b2b1532f4abf93d877c08d1f618eca019406c6af00029011d3b0825"
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
