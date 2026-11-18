class Workmux < Formula
  desc "Git worktrees + tmux windows for zero-friction parallel dev"
  homepage "https://workmux.raine.dev"
  url "https://github.com/raine/workmux/archive/refs/tags/v0.1.283.tar.gz"
  sha256 "2c35dfbfe523b4f59e7e7e23895abfe04a6e64c236538eadaa2ce488308fff8c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "17a04fe7363e41b6fd19d559ee7b45e5963ebb4fb9fdf310da4de98498434029"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "10d283206a5ca0ed922905bbc0dae10b89e5ca52ff84f71795bdbb862b129e5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "55491151f14a0b50707a60725c658731ea42b51e2db881d18c7355d8947565ed"
    sha256 cellar: :any,                 arm64_linux:       "8c5c4e87d602cae2b25ec771f3e529097dcac2f8a0e06898c3b0bf99b4bb4442"
    sha256 cellar: :any,                 x86_64_linux:      "bfd6f71e6e3dcb4bf575e169f64d55f9b5b96be83c93910842b0a21cf59867a3"
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
