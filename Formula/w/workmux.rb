class Workmux < Formula
  desc "Git worktrees + tmux windows for zero-friction parallel dev"
  homepage "https://workmux.raine.dev"
  url "https://github.com/raine/workmux/archive/refs/tags/v0.1.282.tar.gz"
  sha256 "f72fd4d3a6634d7d2ac36d3614883f13788a76c8889058daf247b0e656315d2d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c0d075ee824dafc7c62b590285672bb6b8a892c77471d8335f1678a97d5bcca3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1fc6e9890d8696051742216477da40c85cb2c4124706c5157dcff16a3cedbf88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cab177a8039b884db4776670364add1d7e0c1228ea13ff8069fa6dfc2df97e5a"
    sha256 cellar: :any,                 arm64_linux:       "378b4ea0798c79f89b7e9359efe154e5cc196800b2abf8574c70c2b6fd7a7ff2"
    sha256 cellar: :any,                 x86_64_linux:      "6f8958c97fe74de90135bf8cca244ba7701fa122e124905a528b1cff536de1b0"
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
