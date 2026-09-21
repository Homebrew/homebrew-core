class Workmux < Formula
  desc "Git worktrees + tmux windows for zero-friction parallel dev"
  homepage "https://workmux.raine.dev"
  url "https://github.com/raine/workmux/archive/refs/tags/v0.1.264.tar.gz"
  sha256 "8556029834a960725bc25ad920ca246690e61b6acba1fa9feda9191929dee55c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4f46dc0f3ef624f81a0453ffa54aa65091cc49352b8f243f907257733e0d1839"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2c79731f5d90ed5aec63ba8b7eec3d66fd7aa223d7b317698f916f5c1be62fcb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "51e6f3a1670e2a140a888c00fce60987b0158f070851ab5cce086d8a57fb5083"
    sha256 cellar: :any,                 arm64_linux:       "34a50b821563d9f584e7cd795fcf3cd9a38373b238b3158a3b217f1cc9a26d6a"
    sha256 cellar: :any,                 x86_64_linux:      "c2e6abda41d2ececdc09104ba8e9d29264bde092ac2d1f30434c5caa85c58eef"
  end

  depends_on "rust" => :build
  depends_on "tmux"

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
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
