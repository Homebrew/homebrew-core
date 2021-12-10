class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.16.1.tar.gz"
  sha256 "c5306f93d929bb977ad3b3c9fb30921f1fb258f028a14b50045d61de6b9351ac"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d23f13155021eca174ef0f94259ca73e089cff52ac626939bc63ddefe792fe85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ef5fc41428836a7a2591ee150f3e883b9ae124e1af808dc07e32d08d66340ff"
    sha256 cellar: :any_skip_relocation, monterey:       "16d73c313f515460ee0317c358bd19159f876069cea3f7ef27312c18c2ed1735"
    sha256 cellar: :any_skip_relocation, big_sur:        "974e70d9c920078bd22120fbe51fd90a9f0fe53dbcd808d73b8175ee0e1320cc"
    sha256 cellar: :any_skip_relocation, catalina:       "eec523fc15ca91dbda95d63c4ba64ef01746f204533e5215984b7cf775d15c80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "265078b6a614919f737e7980519a19e5c6b3ebd73de73d249823c9646569ec4e"
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
