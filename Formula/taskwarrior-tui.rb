class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.18.5.tar.gz"
  sha256 "d79aa2c3c6dfe6ee8570077680016e69420b77eea7916b033c34d75c35b61059"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4827d51404308f3d7880a5f3b2fad01f8fb3ac88f5eeb972b8b34eabf1d4e064"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e032bb0cbfe5ab053a3ba35e4b87320d69f4863fffe06986090bae98c489cfad"
    sha256 cellar: :any_skip_relocation, monterey:       "b95371a9e8ed8057677532f3f421491c73b29415c67a113e1b211cea74f07bb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "360c8b3a04940e2df571096eab5480f482d2c3188db0fe2515020b470707fe30"
    sha256 cellar: :any_skip_relocation, catalina:       "784e71b8b6c632288e61d9f0e68ff3fe2fb8ffefb3bf7cc472c0c2283335973e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa4915433d8c2c31ce18f6b972568ebc15417c90a56dd5754a0c5d3cf0e34e4b"
  end

  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/taskwarrior-tui.1"
    bash_completion.install "completions/taskwarrior-tui.bash"
    fish_completion.install "completions/taskwarrior-tui.fish"
    zsh_completion.install "completions/_taskwarrior-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "The argument '--report <STRING>' requires a value but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --report 2>&1", 2)
  end
end
