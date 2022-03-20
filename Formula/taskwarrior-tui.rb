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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a60d4cf7bda3715f3c4d1370e7c4f004d63ff09de8d18ebd5afefea5fefdcae7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a32a19a14f58a10dcbb187860e4299a7d5849b880bdbd518abbe6b5be220b20d"
    sha256 cellar: :any_skip_relocation, monterey:       "fda948595670da208b3fa9081d2959bad7dabf556ba5b7ee044a2a80b8cf98cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "471959d31cbc3b2f793ca8ac1c7f2776ec9563a560eadad506882d93ffcd4f11"
    sha256 cellar: :any_skip_relocation, catalina:       "c394cc35a4287c683c362af2f5bb1f8315b7b296f0bbd68e6ac29267bfbf25a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f1e345c62cad66da78d2413f592cfdf415032edca2e4c552ea1210e9e36b12f"
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
