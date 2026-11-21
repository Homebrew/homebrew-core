class Workmux < Formula
  desc "Git worktrees + tmux windows for zero-friction parallel dev"
  homepage "https://workmux.raine.dev"
  url "https://github.com/raine/workmux/archive/refs/tags/v0.1.284.tar.gz"
  sha256 "d56db075ebdd1f3d176f10219bfa1ed0b6c20e97b5290236a37e0a172c5a2d79"
  license "MIT"

  bottle do
    manifest_sha256 "2b2a34e4cfdc8e6c4512358ce3d99d1a95bf61f11863bc38b967ef81f7872c31"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aaba6e30ad28644b410c686252d5b16d0dcc7ef58ec7d98fb874105b820c26db"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d083101cbd953ce8d039451b427662077d32a8dc0fadfcb9554eb016bd97a224"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c6225adee6c060a0162cb23f349e3d45a41fa244d206e9b6dda9011cf288280d"
    sha256 cellar: :any,                 arm64_linux:       "b577530be0a7fcae093da2e8447c0bd9a688178dec408d94ca7baf1da74eede0"
    sha256 cellar: :any,                 x86_64_linux:      "51dd516190d33d761abf827f6c14fc8b523a458431c468ac92ff16b7315ec1f1"
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
      server_pid = shell_output("tmux -S #{socket} display -p '\#{pid}'").chomp
      ENV["TMUX"] = "#{socket},#{server_pid},0"

      assert_match "Successfully created worktree and tmux window", shell_output("#{bin}/workmux add brew-test")
      assert_equal (testpath/"repo__worktrees/brew-test").to_s, shell_output("#{bin}/workmux path brew-test").chomp
    ensure
      system "tmux", "-S", socket, "kill-server"
    end
  end
end
