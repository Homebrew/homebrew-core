class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.23.6.tar.gz"
  sha256 "df327b434982c14e8b4bd6f3fbed4b78f4aac04c0b30584a552c3032669d9076"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f98342eed8229f92a42818ecac0940b51f1d53710a4f1c4cfcc6e87a9c2649b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "add2ce23d96a32745e2691724320a25674cb283367a59e2cd2bca40dedb8e8bd"
    sha256 cellar: :any_skip_relocation, monterey:       "221e62b7e68bd346022146337708714d9ba2d46df2e2ebf6b830ce22117e0f35"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a180793f3ef67cce9e5dc162e5ac0e52336e0f013844bd273f1c7bfd75f7c17"
    sha256 cellar: :any_skip_relocation, catalina:       "bc823f692c67afa5937a52378f3f15d24d8fb431039916b4cdf4884cafb37501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f4ac2de21938b68ee3f4487e54eb96307f157357635b8a05ffeab77244da287"
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
