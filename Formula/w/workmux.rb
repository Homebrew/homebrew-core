class Workmux < Formula
  desc "Git worktrees + tmux windows for zero-friction parallel dev"
  homepage "https://workmux.raine.dev"
  url "https://github.com/raine/workmux/archive/refs/tags/v0.1.279.tar.gz"
  sha256 "da4516ff1fcd8ef4fd7f74641d2fb77f0af9cd5bc53db2b39c1e17b242099698"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "183404bf584813a3904498e381c08875be5951129b984247b310ac845c744bbf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b8f92049440f230915959673893cad5e820f558f58b6322f3c92ba79deed9816"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4cadf835212f88d85308d02cf901d412df74ab3ecec204603355d621a1749452"
    sha256 cellar: :any,                 arm64_linux:       "9602a9531164d82fd0cf423e9d9ffbc974732975869c933bdacb2a4332ca6537"
    sha256 cellar: :any,                 x86_64_linux:      "4ef89501a31424f42631f27e6ebfd37899a6403ebdc918e3c76b77da83558df5"
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
