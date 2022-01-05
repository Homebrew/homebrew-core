class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.17.0.tar.gz"
  sha256 "4377d3822b2fad6d4a911b4598ff981fae1b97c658e27474bf27178fbef1b38f"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "096a9634a547c242672e2053707d55950a6fdad39a8cd18cb99bb97d1cc7bc3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33d133c2a13ead267da9dab41976ec55bb6b574bd330c9772a6faeeeceb44024"
    sha256 cellar: :any_skip_relocation, monterey:       "0891e8c5daa9728c9614eb1971632d1606ed0e33572517a573f94d6fe1898810"
    sha256 cellar: :any_skip_relocation, big_sur:        "05e79bb0bd25699cb3c3fdbef663723fa5f39803a1bde247bb601147458fa3ac"
    sha256 cellar: :any_skip_relocation, catalina:       "0afb078c35f1d27496036b66f118edfa9109ccf2c6fd5597a12ad5d21e2df37c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c4b078b38c37698df71de50931fd90d57cf2b1fee91bba6be17010789732bc5"
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
