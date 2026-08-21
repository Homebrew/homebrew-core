class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.74.0.tar.gz"
  sha256 "2aa5223d3a0e4bdc0bbd114da5cf1a801ac637397cd2e89271e4c2589f248eb9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "957b0877b66aade64e9f216bdadd844350c678da5bbf36960f6675fec12d968e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0d0330c0065680d6b9ec4ce7224d7fe30a324a32dace6e2ee3f5d7480af0feb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85f9937007be4a43d502ed238bf928657c754a93f46692c20ca4a3ff44c263a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e876a53550913cd7620e6f73761838b350d8fb66acb810c728af17fb69cc19f"
    sha256 cellar: :any,                 arm64_linux:   "d95ae1236553c2431cd5a0756417ee690ab09eab71cd0c17b28b4ec4d3aeeb23"
    sha256 cellar: :any,                 x86_64_linux:  "1910774ff0627abbd12549204fb74fa28a42b84669882482d76a9ed67a42d536"
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
      output = shell_output("#{bin}/wt list 2>&1")
      assert_match "Showing 1 worktree", output
    end
  end
end
