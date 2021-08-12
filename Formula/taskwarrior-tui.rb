class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.29.tar.gz"
  sha256 "999a166f51c6ba596627725799fe6eb9de34360aee2d18a637f22f45a9efd2a3"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "43dfabbc4d93c719825560da59aba929e33b6bedf8e1e3c99d9b4f502d408371"
    sha256 cellar: :any_skip_relocation, big_sur:       "dbd737595be382b6e5e0369dd986b4d7ce084649a46712522f58f7471b3c4e98"
    sha256 cellar: :any_skip_relocation, catalina:      "da8366e0156b9c38283b15a8721cc7c5387fcce435d8759de1c1425fe9a05669"
    sha256 cellar: :any_skip_relocation, mojave:        "12e8871d117f4024c982f0c00d7d09083ac57ce325fb329c2d356ee0b9b8acbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e1baa8985ff235458478f76276b9ac65e3443cde6e9058efe6fbc657351467b"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args

    args = %w[
      --standalone
      --to=man
    ]
    system "pandoc", *args, "docs/taskwarrior-tui.1.md", "-o", "taskwarrior-tui.1"
    man1.install "taskwarrior-tui.1"

    bash_completion.install "completions/taskwarrior-tui.bash"
    fish_completion.install "completions/taskwarrior-tui.fish"
    zsh_completion.install "completions/_taskwarrior-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "The argument '--config <FILE>' requires a value but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --config 2>&1", 2)
  end
end
