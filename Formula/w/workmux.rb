class Workmux < Formula
  desc "Git worktrees + tmux windows for zero-friction parallel dev"
  homepage "https://workmux.raine.dev"
  url "https://github.com/raine/workmux/archive/refs/tags/v0.1.276.tar.gz"
  sha256 "6caf4d834af5088ce5b1bb6ee2f65127ac31e1e1d7133e38a99e73d3b41b0770"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dc2b934281d55863985215892e829733abc7f1c12ff36f9ca2a37196bc35d5e6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "14dd3c695899aa209105a66e5f8fdcbfd502015ded6946c340f64d0bbc2aae50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9502b91775a4e7263fde03706be363fa78d5cf03ecb83e56443bd8167332a801"
    sha256 cellar: :any,                 arm64_linux:       "5a34baf2ec88dacf87008bda0943053740196ca0135132ce6d32cec4964632c2"
    sha256 cellar: :any,                 x86_64_linux:      "6a3413ae50496b6b04bc1e2506aac0393870fbbdea0c2207b3c2052106750fb3"
  end

  depends_on "rust" => :build
  depends_on "tmux"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"workmux", "completions")
  end

  test do
    socket = testpath/"tmux.sock"
    mkdir testpath/"repo" do
      system "git", "init"
      system "git", "-c", "user.name=brew", "-c", "user.email=brew@test", "commit", "--allow-empty", "-m", "init"
      system "tmux", "-S", socket, "new-session", "-d"
      ENV["TMUX"] = "#{socket},#{shell_output("tmux -S #{socket} display -p '\#{pid}'").chomp},0"

      assert_match "Successfully created worktree and tmux window", shell_output("#{bin}/workmux add brew-test")
      assert_equal (testpath/"repo__worktrees/brew-test").to_s, shell_output("#{bin}/workmux path brew-test").chomp
    ensure
      system "tmux", "-S", socket, "kill-server"
    end
  end
end
