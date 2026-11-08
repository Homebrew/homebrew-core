class Workmux < Formula
  desc "Git worktrees + tmux windows for zero-friction parallel dev"
  homepage "https://workmux.raine.dev"
  url "https://github.com/raine/workmux/archive/refs/tags/v0.1.281.tar.gz"
  sha256 "2e283723a205047852a77c3c1d99f065ed427e30c2dbf8940ae9ab047ff06462"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dcbdbf7217b6a00ae733120d4208945e099be07ee6c2c8ec248b07a2f4aac3bc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f322f2242ea7a2660d4ba5f067473abf839b09ca5b6ed89ede1206676acabe7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d599a948e5916da7494130d856d27c10843bc59cc91aec280724e969c3f12776"
    sha256 cellar: :any,                 arm64_linux:       "b4223f634d0c5fa7312e9b3a76d4842f5ada62326490d6a9974451ebaffcbaeb"
    sha256 cellar: :any,                 x86_64_linux:      "6ff31d3ae8513b30afc634943f34267205ec2819d4360b3c5e041eb28aa7ecb4"
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
