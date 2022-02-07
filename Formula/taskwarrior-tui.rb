class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.19.1.tar.gz"
  sha256 "a591f3e07e4c0dfb7569249f3bbc5be4a58b3272c786b630a8454090f6cca07a"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2827b139b67d9caafd4612c07c6d1bd7c2e320445a46031154478c92801a5c43"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4d519862c8b729de8779464ed47cc38297a7350cb319a16043633f7f3fab427"
    sha256 cellar: :any_skip_relocation, monterey:       "1fdb1dae05c7ab3a4cb6ce25e84e0c20d2af382e1c93119e13a619bcb509a354"
    sha256 cellar: :any_skip_relocation, big_sur:        "706a243aec3458049d9430aa8af3fd72dabda4e8fe6e79c167f3db6ac51ccb2b"
    sha256 cellar: :any_skip_relocation, catalina:       "4cc3a94e3b1a0f4ca4708688ef26a7e2c6d07b3e54ecb892b63ea022f7556618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81a56f495ba61ec05cc9d99acc5697309f1bfa145ff9df58ea9364471e5aca65"
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
