class Workmux < Formula
  desc "Git worktrees + tmux windows for zero-friction parallel dev"
  homepage "https://workmux.raine.dev"
  url "https://github.com/raine/workmux/archive/refs/tags/v0.1.280.tar.gz"
  sha256 "6043f69f090fdf67cbc041ef21c1a583260f0813e462775a1c1b32f42e60d12e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1ca786ea51031513a746dab0f41803a32dc744ceb7f53fb5b4a565ce9f1bf5fd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8d5698e681a15dd2e3c8b87093ce72f1ad0a00e0d146c8fe6f17851521da555d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "52c20f75948940f0f37f30efee87aff9d3171c2fa3b9e52820673fb445be1680"
    sha256 cellar: :any,                 arm64_linux:       "6b57b0e3e8182faa44bb33b31d6bc2a725b59dcde17ed6ff2eff0075692f4ee2"
    sha256 cellar: :any,                 x86_64_linux:      "b1b8cf6ea2398418973b8ff8af2ecb1966fb56fa99f64f20be9cc438f7960613"
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
