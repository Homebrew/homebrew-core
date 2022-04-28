class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.23.2.tar.gz"
  sha256 "f9fe00e824970b906968348744af525fc43db948a9151ad7158f4802baa03da7"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0287852a879632b42dafccff82d05874c4b385f7cef4a13c8b931d6871dbacb8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc7cfeab6b12c88e5a0f6b7398ffa89d37c9192f8d20db3c5f1c39bbc99611ce"
    sha256 cellar: :any_skip_relocation, monterey:       "6a1d5b5157922cf939e3da0012dc4206d3bc282bfb34705cdcf1641668d6a2fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "a54170a6d6e54e8185ffc70811322f9a5ce19d5c07c7ce78d5a91a5492c5f636"
    sha256 cellar: :any_skip_relocation, catalina:       "8a90d61fe493b398955d011df4bfc6c0ac0e866b4a87f07e5fb29d4b8c535b0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cbee7c9e75b845bd3b73e3af5c324700756edcb6a641734d480851b19675254"
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
