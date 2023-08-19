class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.25.1.tar.gz"
  sha256 "52be07ec3331b830b1fa626e0da9a2196aa861db0bd04653445d009c74322361"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9fb215c70f38c00a4ea26ca86794b785a77fecf6f7c73179d8349757107b8e2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d93f84b62d236ae6a5c087608ed8bf817eb752fbd75ba6649b9f8da8220135c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d7eb47ff3b55c12464d9c025dac8dda6f803a0eed814ec31d359a7bb86b4104"
    sha256 cellar: :any_skip_relocation, ventura:        "280b68740275379103d17a566f5af5a60eb625be31e4493a35eaa46a0241546b"
    sha256 cellar: :any_skip_relocation, monterey:       "9d701c4e984401e9712c98cfb6fbaa2b49e3bc1f2f21e357bde6df6ddc2d544c"
    sha256 cellar: :any_skip_relocation, big_sur:        "911d5b5f0d4954d56ce72d56d6e758ae09ef0fabdfca51e58e639a9a740ea911"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5aee91a1e5c66899a5561bb625d13b5488a870bc760a0886e353c56fa72a6fcf"
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
    assert_match "a value is required for '--report <STRING>' but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --report 2>&1", 2)
  end
end
