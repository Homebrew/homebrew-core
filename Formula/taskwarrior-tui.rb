class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.21.0.tar.gz"
  sha256 "9d73e9380e794fc1a3b0623d64caaf8cfd812b0dadcc83770101632347e1a068"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "469fb0176a363cb4b12c414de6a102ef1f6cc07dd074ae91e03bd438d28b0384"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8ec24b7ab52c8caf12e31a617ffa2141f60d6b3a52320c16dee31e64f018ce2"
    sha256 cellar: :any_skip_relocation, monterey:       "0e70c3168140f923e4203d68800675a7db8c8dbdafac731e05870296517ef116"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b215d9fbf427aa0060c278ad8b90eff32a2ee84be18f049fe3f8afc4bbe9e1d"
    sha256 cellar: :any_skip_relocation, catalina:       "49e3b67cb9ba53c1b1f77f0c1f73693393cc4c439f98836f0a71b7d2d1257e5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb954c8b4a3ac6041351d1bf0c0d2d63ad6a7dd0b97a4614f1fceca19b1e7f2f"
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
