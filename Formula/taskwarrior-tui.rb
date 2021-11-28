class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.15.0.tar.gz"
  sha256 "9f8ed1257ab6d4608dd73f61ee8542ff3b1b112d201b746c1ba90aa939c1c8ed"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b869d051825f5ee764afcecc44d7c1872ef2bb7ccf26e85a2bd7d443d53cb83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0786a221979df2109d09d783d7b51a77291e9e80cf43b79f326812cca708e06"
    sha256 cellar: :any_skip_relocation, monterey:       "7c3a51af8e738be9a8c6d6152354067b430761fa032025cbce280d04585fc33d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a42a6d6a498cbc0839cfee26477a0ea896cd04c964a55d52598bc7e4fceac886"
    sha256 cellar: :any_skip_relocation, catalina:       "e5b4d8aa731020d2fce452465969ac9bbbaa844d28432338f471bef6a9dc270f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b297d5bb260dd661d112df138a79f45058c3799112cd9123aac05959ea772d09"
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
