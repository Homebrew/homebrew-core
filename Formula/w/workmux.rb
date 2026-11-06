class Workmux < Formula
  desc "Git worktrees + tmux windows for zero-friction parallel dev"
  homepage "https://workmux.raine.dev"
  url "https://github.com/raine/workmux/archive/refs/tags/v0.1.279.tar.gz"
  sha256 "da4516ff1fcd8ef4fd7f74641d2fb77f0af9cd5bc53db2b39c1e17b242099698"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ed7519999e4b4080c8d9a69e5e7e6bff5a1655dbabaed06737d0d326a275cc3a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1c8267a59cd095ec9568cee11a5ea6eb8aab4b255f77eb083499146c19114b25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5364aa1366e5627c67aef876d91ae6bf8f2cc6c9589418815608f51e015ae46e"
    sha256 cellar: :any,                 arm64_linux:       "d1faa073306421e905918f45b1e560819e0a877b7bcfa3b8ceae4ee86771bc0f"
    sha256 cellar: :any,                 x86_64_linux:      "a8a425ef5dc6048be29f8f6a29606234026f55e45f48a0f5d83f5598ed67dbbb"
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
