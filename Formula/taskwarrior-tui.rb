class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.23.4.tar.gz"
  sha256 "a394994c545ddfc382b14e34b9d348d9df03caf906273b77b1f23c78e0928aa3"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa1018ecf99031fa01e72f9339d89df58b5c2ee4719d1cec44abd5277d854c81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7f2e91ae52bb81aa55edc11e8b34827ce646c382d75f4ddb9a9d790fe1cd4d1"
    sha256 cellar: :any_skip_relocation, monterey:       "af4666a7097b1148d9de1346c898a858f78d40dd27ae9acd32b99c01f27909a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "e06e435ed2cca7cb15475ee67e245f3e61013b7442febb8af0977fcc0cdb47e2"
    sha256 cellar: :any_skip_relocation, catalina:       "191538ee1d068c8ec85ad8666444a4284841ac67284e9a18e5ad6196a72d3816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e0f4e903434711b1b91487a88809f82c9e5f0b08914a180741d6f5c145e4373"
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
