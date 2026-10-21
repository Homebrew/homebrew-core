class Worktrunk < Formula
  desc "CLI for Git worktree management, designed for parallel AI agent workflows"
  homepage "https://worktrunk.dev"
  url "https://github.com/max-sixty/worktrunk/archive/refs/tags/v0.81.0.tar.gz"
  sha256 "ab5cbc30f9b07b2ccb2133813f100deda77731dad0ce440332a34090de165d2d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/max-sixty/worktrunk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "923c679f92cd4333a0d5799dc312a3a89bfc57c84862cd9bb247f4cd95f44a3a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "943e60352f796ed3236ba6c90c05d317aa4bb34abba09fbad789d3b22ddf0399"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "16a66cef69d1c092e3caa0c56325c14df39106b230456c3a4204479f71cf7bfb"
    sha256 cellar: :any,                 arm64_linux:       "97db01f3def017662d9bb3224bffb5a668266ea4fa49398850787b3ecbcd48da"
    sha256 cellar: :any,                 x86_64_linux:      "9a9e9b909fbfbbc85af57a1519c7176213bc65324cefd04dd18673f782016653"
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
