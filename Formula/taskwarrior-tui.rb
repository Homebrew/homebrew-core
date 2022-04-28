class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.23.3.tar.gz"
  sha256 "9c62d58c14cfebc10cc606f967046076adac8b730c37c2b8caa706b3947d7398"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5836dbd5c672e288b9f43ee0bfdc2d8032b7f67a66213eec37962251b8476ba6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f1bbbae23d5b08226ffa5815a68da6af1d69f530385f77f21c3f2f68d86dca0"
    sha256 cellar: :any_skip_relocation, monterey:       "cec1b73bd2d76c7d943886c49373b6d5ab71a2105baa9da2f9958929c6ea6dfb"
    sha256 cellar: :any_skip_relocation, big_sur:        "8246fd30d2490bd834085f778694d9a24246db68a4aa46f1662a6066bfea8788"
    sha256 cellar: :any_skip_relocation, catalina:       "a0983fb591ecdf68538b79c510d38d1dc475a9cc8538252aa99ac2b9c73633d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b732dbbdba6012171d0941705fd04ec7392aa6a2977287c00a819a1afefb3b0"
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
