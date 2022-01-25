class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.18.4.tar.gz"
  sha256 "db7321b39fe75059b7205ddcb901afdc690e025cdcf5b2278cc73594f04074b2"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f19e0d7f1d2851befa43a7e9957b62ebae8a1e423fc502bcf8815190d320169"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df310ae2586b85fad05bd3730a800a85be9b41b8c3eba69c3c2a5b1266501334"
    sha256 cellar: :any_skip_relocation, monterey:       "e0e2e728ad50f589652102b9406c454b76906a8e55f5602554c72a558eeac695"
    sha256 cellar: :any_skip_relocation, big_sur:        "74f547bd84a070acc88892b4a93dfae1cad9c67e486d9df12a93df84fe68406c"
    sha256 cellar: :any_skip_relocation, catalina:       "4970f651e5a8a26183707a3b3a6705e94ab5f5c1f1219996ab2d603794379446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17d158a555c19194cf6daf28f09036e61926b96344f3d2a0e957d09c140bcf32"
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
