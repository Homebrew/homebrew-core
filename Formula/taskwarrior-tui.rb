class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.23.5.tar.gz"
  sha256 "3d2596ccd73ea0c879b93ff08f156636c167293700dcc5dfd2c9324928c9639b"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fb5dbf3009c82fed2d5b51a2193c3a81003b8817fd8e3f4acd1b45ed9b53b82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "13a0c469fdb75866f8aa12b47b3898465ec6abc20a4827ed61614760f5b28f19"
    sha256 cellar: :any_skip_relocation, monterey:       "99b5341e726ec525cf309cd138276ad5d37ca0a5e6ea77991c00049199920c44"
    sha256 cellar: :any_skip_relocation, big_sur:        "f28de511d49c68cf5475b2a2b83d3629e82914363adda04603017668c462f519"
    sha256 cellar: :any_skip_relocation, catalina:       "e0b21488ce7cd1a5f6fa5c0b67aa5fb27bb0bbcbbd0eb1ee535cc39293d0a729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b0be92e8309ca25f43edc9635cb4fedf97d5d906981402a5cc6913eb7278866"
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
