class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.19.3.tar.gz"
  sha256 "4548c0db12dd8b9e833a38ecd5f849bcb6ac76ac7250432ffe251e79880c3121"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70a835806855b6524f254dff729bfeeae19e13e8b6bf6998d4b9f8c520619122"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "809b95af6aa75d62b05daca21c7651118ee7315eec3ffe7a1eb7d7206a00ab83"
    sha256 cellar: :any_skip_relocation, monterey:       "25a365cad7a5310cf3a3c720e1330efddf1f1263c5f5de88f74fa5a1845476ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c2a6b372d2c7d7098da1c9ff25900a5d4c6ddf33d3875d4370aa08b4d2a153e"
    sha256 cellar: :any_skip_relocation, catalina:       "6823849573073476092019bcaf13f7bae47fff6943003c911c5282649b2486ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47c415fc7989a6713c510375d20be3c52292f41c504afadcc109eaf6a2910761"
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
