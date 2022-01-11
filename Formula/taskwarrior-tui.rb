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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49d331675d9c676517f322837d7926ceb37d87cb886ad727e66861b89fa88723"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0d9b41884f9e5ba577a2fc0181d465212806d1b0038ed4cc1113e5d631fa621"
    sha256 cellar: :any_skip_relocation, monterey:       "e4f761a9dc4342e7f260cd92a2f1d99dd330306589bb1ccc96b63d115290ff93"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d9c7c1840a5dd20bcba90b23fff50b4245c952ca41b786e3de62773db7536de"
    sha256 cellar: :any_skip_relocation, catalina:       "3fc99ff85ed8ac279a5198316f351e5840600ed3978f14b610c8450ef4aa0547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68a8855d8db677bc237f6f424bfed778a69b84fa7075c9ee8e172918e26d521c"
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
